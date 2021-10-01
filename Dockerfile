FROM centos:7

MAINTAINER "Riley Schuit"

# Allows installation of tzdata to run unattended
ARG DEBIAN_FRONTEND=noninteractive

# Specify encoding to prevent Python from assuming it's ASCII.
# Prevents errors similar to: https://github.com/mroosmalen/nanosv/issues/45
ENV LC_CTYPE en_US.UTF-8
ENV LANG en_US.UTF-8

# Ansible version 2.4 and later can manage operating systems that contain Python 2.6 or higher. BIG-IP 11.6 ships with
# Python 2.4.
ENV ANSIBLE_VERSION 2.8.10

# These installs must be done before we install the rest of the packages are installed via yum.
# - epel-release must be installed ahead of time so that the install of python-pip doesn't fail.
ENV YUM_PACKAGES_1 \
    epel-release

ENV YUM_PACKAGES_2 \
    curl \
    epel-release \
    expect \
    gcc \
    git \
    iproute2 \
    iputils-ping \
    jq \
    make \
    net-tools \
    python-devel \
    python-pip \
    python36 \
    python36-pip \
    ssh \
    sshpass \
    tcpdump \
    bind-utils

# These installs must be done before we install the rest of the Python modules.
# - setuptools must be upgraded to at least version >=1.4 or else suds-jurko will fail to install.
# - pip must be upgraded from 8.1.2 or else later module installs fail.
ENV PIP_PACKAGES_1 \
    pip \
    setuptools<45

ENV PIP_PACKAGES_2 \
    ansible==${ANSIBLE_VERSION} \
    asn1crypto==0.24.0 \
    bcrypt==3.1.4 \
    bigsuds==1.0.6 \
    certifi==2018.4.16 \
    cffi==1.11.5 \
    chardet==3.0.4 \
    cryptography==2.4.2 \
    dnspython==1.15.0 \
    enum34==1.1.6 \
    f5-icontrol-rest==1.3.8 \
    f5-sdk==3.0.14 \
    idna==2.6 \
    Jinja2==2.10 \
    jmespath==0.9.4 \
    MarkupSafe==1.0 \
    netaddr==0.7.19 \
    paramiko==2.4.1 \
    passlib==1.7.1 \
    pipe \
    pyasn1==0.4.5 \
    pycparser==2.18 \
    pycrypto==2.6.1 \
    PyNaCl==1.2.1 \
    python-etcd==0.4.5 \
    PyYAML==3.12 \
    requests==2.18.4 \
    six==1.11.0 \
    suds==0.4 \
    ansible-tower-cli==3.3.6 \
    suds-jurko==0.6 \
    urllib3==1.22 \
    zabbix-api==0.5.4

# python3 is used explicitly by a few things and need some additional libraries
ENV PIP3_PACKAGES_1 \
    ansible-tower-cli==3.3.6 \
    Jinja2==2.10

RUN yum -y update \
 && yum -y upgrade \
 && yum -y install ${YUM_PACKAGES_1} \
 && yum -y install ${YUM_PACKAGES_2} \
 && yum clean all

RUN pip install --upgrade --no-cache-dir ${PIP_PACKAGES_1} \
 && pip install --upgrade --no-cache-dir ${PIP_PACKAGES_2} \
 && pip3 install --upgrade --no-cache-dir ${PIP3_PACKAGES_1}

# Ansible specific environment variables
ENV ANSIBLE_HOST_KEY_CHECKING="False" \
    ANSIBLE_LIBRARY="/ansible/library" \
    ANSIBLE_RETRY_FILES_ENABLED="False" \
    INTERPRETER_PYTHON="/usr/bin/python2.7" \
    PATH="/ansible/bin:$PATH" \
    PYTHONPATH="/ansible/lib"

WORKDIR /ansible/playbooks

ENTRYPOINT ["ansible-playbook"]
