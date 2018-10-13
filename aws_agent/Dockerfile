FROM gocd/gocd-agent-centos-7:v18.8.0
RUN yum -y install epel-release && yum clean all
RUN yum -y install python-pip
RUN yum -y install epel-release git sudo wget ansible openssh-server openssh-clients tar yum-plugin-ovl \
    && pip install awscli \
    && pip install boto \
    && yum upgrade python-setuptools