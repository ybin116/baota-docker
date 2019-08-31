FROM centos:latest
MAINTAINER yarmy bin@mlia.cn

COPY entrypoint.sh /home/entrypoint.sh

RUN cd /home \
    && curl -o install.sh http://download.bt.cn/install/install_6.0.sh \
    && mkdir /etc/backup/ \
    && mv /etc/yum.repos.d/* /etc/backup/ \
    && curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo \
    && yum install -y wget \
    && mkdir -p /www/letsencrypt \
    && ln -s /www/letsencrypt /etc/letsencrypt \
    && mkdir /www/init.d \
    && rm -f /etc/init.d  \
    && ln -s /www/init.d /etc/init.d \
    && echo y | bash install.sh \
    && bash /www/server/panel/install/install_soft.sh 1 install php 5.6 \
    && bash /www/server/panel/install/install_soft.sh 1 install php 7.3 \
    && bash /www/server/panel/install/install_soft.sh 1 install nginx 1.16 \
    && bash /www/server/panel/install/install_soft.sh 1 install mysql 5.7 \
    && rm -rf /www/server/nginx/src \
    && chmod +x entrypoint.sh
    
COPY pythonmamager_install.sh /www/server/panel/install/pythonmamager_install.sh
COPY supervisor_install.sh /www/server/panel/install/supervisor_install.sh

RUN cd /www/server/panel/install \
    && chmod +x pythonmamager_install.sh \
    && chmod +x supervisor_install.sh \
    && bash pythonmamager_install.sh install \
    && bash supervisor_install.sh install \
    && yum clean all
    
CMD /home/entrypoint.sh
VOLUME ["/www"]