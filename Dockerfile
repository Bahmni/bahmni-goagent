FROM gocd/gocd-agent-centos-6:v18.8.0
ARG mysql_password
RUN echo -e "[bahmni] \nname=Bahmni development repository for RHEL/CentOS 6\nbaseurl=http://repo.mybahmni.org/rpm/bahmni/\nenabled=1\ngpgcheck=0\n" > /etc/yum.repos.d/bahmni.repo \
    && rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm \
    && yum -y install epel-release python-pip git sudo wget ansible bahmni-installer* \
    && wget https://mirror.its.sfu.ca/mirror/CentOS-Third-Party/NSG/common/x86_64/jre-7u79-linux-x64.rpm -O /opt/jre-7u79-linux-x64.rpm \
    && wget https://mirror.its.sfu.ca/mirror/CentOS-Third-Party/NSG/common/x86_64/jre-8u101-linux-x64.rpm -O /opt/jre-8u101-linux-x64.rpm \
    && wget https://mirror.its.sfu.ca/mirror/CentOS-Third-Party/NSG/common/x86_64/jdk-8u101-linux-x64.rpm -O /opt/jdk-8u101-linux-x64.rpm \
    && rpm -ivh /opt/jre-7u79-linux-x64.rpm \
    && rpm -ivh /opt/jre-8u101-linux-x64.rpm \
    && rpm -ivh /opt/jdk-8u101-linux-x64.rpm \
    && rm -rf /opt/jre-* \
    && rm -rf /opt/jdk-*
ADD ./ansible_playbook /ansible_playbook
ENV ANSIBLE_PLAYBOOK_PATH "ansible_playbook/"
WORKDIR $ANSIBLE_PLAYBOOK_PATH
RUN ansible-playbook -i inventory all.yml --extra-vars="mysql_password=$mysql_password" -vvv
RUN rm -rf $ANSIBLE_PLAYBOOK_PATH
WORKDIR /
ADD ./scripts /scripts
RUN chmod a+x /scripts/*
