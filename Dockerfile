FROM gocd/gocd-agent-centos-6:v18.8.0
ARG mysql_password
RUN echo -e "[bahmni] \nname=Bahmni development repository for RHEL/CentOS 6\nbaseurl=http://repo.mybahmni.org/rpm/bahmni/\nenabled=1\ngpgcheck=0\n" > /etc/yum.repos.d/bahmni.repo \
    && rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm \
    && yum clean all \
    && yum -y install epel-release python-pip git sudo wget ansible openssh-server openssh-clients tar yum-plugin-ovl bahmni-installer* java-1.8.0-openjdk-devel \
    && pip install awscli \
    && pip install boto \
    && yum upgrade python-setuptools \
    && rpm -ivh https://mirror.its.sfu.ca/mirror/CentOS-Third-Party/NSG/common/x86_64/jre-7u79-linux-x64.rpm \
    && rpm -ivh https://mirror.its.sfu.ca/mirror/CentOS-Third-Party/NSG/common/x86_64/jdk-7u80-linux-x64.rpm \
    && rpm -ivh https://mirror.its.sfu.ca/mirror/CentOS-Third-Party/NSG/common/x86_64/jre-8u101-linux-x64.rpm \
    && rpm -ivh https://mirror.its.sfu.ca/mirror/CentOS-Third-Party/NSG/common/x86_64/jdk-8u101-linux-x64.rpm
ADD ./ansible_playbook /ansible_playbook
ENV ANSIBLE_PLAYBOOK_PATH "ansible_playbook/"
WORKDIR $ANSIBLE_PLAYBOOK_PATH
RUN ansible-playbook -i inventory all.yml --extra-vars="mysql_password=$mysql_password" -vvv \
    && wget -O /etc/bahmni-installer/local https://raw.githubusercontent.com/Bahmni/bahmni-tw-playbooks/master/inventories/aws_qa04 \
    && wget -O /etc/bahmni-installer/local https://raw.githubusercontent.com/Bahmni/bahmni-tw-playbooks/master/inventories/aws_qa04 \
    && yum install -y ftp://195.220.108.108/linux/Mandriva/devel/cooker/x86_64/media/contrib/release/mx-1.4.5-1-mdv2012.0.x86_64.rpm \
    && echo -e "selinux_state: disabled \npostgres_version: 9.2 \ntimezone: Asia/Kolkata \nimplementation_name: default \nbahmni_support_group: bahmni_support \nbahmni_support_user: bahmni_support \nbahmni_password_hash: $1$IW4OvlrH$Kui/55oif8W3VZIrnX6jL1 \nbahmni_repo_url: http://repo.mybahmni.org/rpm/bahmni/ \nopenerp_url: https://erp-$container_name.mybahmni.org \ndocker: yes " > /etc/bahmni-installer/setup.yml \
    && sed -i "1,100 s/^/#/" /opt/bahmni-installer/bahmni-playbooks/roles/dcm4chee-oracle-java/tasks/main.yml \
    && pip uninstall -y docutils \
    && bahmni -ilocal install
RUN rm -rf $ANSIBLE_PLAYBOOK_PATH
WORKDIR /
ADD ./scripts /scripts
RUN chmod a+x /scripts/*