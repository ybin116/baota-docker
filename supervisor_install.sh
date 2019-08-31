#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
install_tmp='/tmp/bt_install.pl'
public_file=/www/server/panel/install/public.sh
if [ ! -f $public_file ];then
	wget -O $public_file http://download.bt.cn/install/public.sh -T 5;
fi
. $public_file
download_Url=$NODE_URL
echo $download_Url
pluginPath=/www/server/panel/plugin/supervisor

# 安装
Install_Supervisor()
{
    pip install supervisor
    mkdir -p /etc/supervisor
    echo_supervisord_conf > /etc/supervisor/supervisord.conf

	mkdir -p $pluginPath
	mkdir -p $pluginPath/log
	mkdir -p $pluginPath/profile
	echo '正在安装脚本文件...' > $install_tmp
	wget -O $pluginPath/supervisor_main.py $download_Url/install/plugin/supervisor/supervisor_main.py -T 5
    wget -O $pluginPath/config.py $download_Url/install/plugin/supervisor/config.py -T 5
	wget -O $pluginPath/index.html $download_Url/install/plugin/supervisor/index.html -T 5
	wget -O $pluginPath/info.json $download_Url/install/plugin/supervisor/info.json -T 5
	wget -O $pluginPath/icon.png $download_Url/install/plugin/supervisor/icon.png -T 5
	wget -O $pluginPath/install.sh $download_Url/install/plugin/supervisor/install.sh -T 5
	\cp -a -r $pluginPath/icon.png /www/server/panel/BTPanel/static/img/soft_ico/ico-supervisor.png

    python /www/server/panel/plugin/supervisor/config.py
    supervisord -c /etc/supervisor/supervisord.conf
    supervisorctl reload  
	echo '安装完成' > $install_tmp
}

# 卸载
Uninstall_Supervisor()
{
	supervisorctl stop all
    rm -rf $pluginPath
	rm -rf /etc/supervisor
	pip uninstall supervisor -y
}

if [ "${1}" == 'install' ];then
	Install_Supervisor
elif [ "${1}" == 'uninstall' ];then
	Uninstall_Supervisor
else
    echo 'Error'
fi

