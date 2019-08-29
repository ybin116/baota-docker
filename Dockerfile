FROM centos

MAINTAINER yarmy bin@mlia.cn

WORKDIR /root

ADD entrypoint.sh .

RUN yum -y install wget \
    && chmod a+x entrypoint.sh \
    && curl -o install.sh http://download.bt.cn/install/install_6.0.sh \
    && bash install.sh

ENTRYPOINT ["/root/entrypoint.sh"]
