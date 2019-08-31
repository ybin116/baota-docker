FROM centos:latest
MAINTAINER yarmy bin@mlia.cn

COPY entrypoint.sh /home/entrypoint.sh
COPY install_6.0.sh /home/install_6.0.sh

RUN cd /home \
    && mkdir /etc/backup/ \
    && yum install -y wget \
    && mkdir -p /www/letsencrypt \
    && ln -s /www/letsencrypt /etc/letsencrypt \
    && mkdir /www/init.d \
    && rm -f /etc/init.d  \
    && ln -s /www/init.d /etc/init.d \
    && echo y | bash install_6.0.sh \
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
