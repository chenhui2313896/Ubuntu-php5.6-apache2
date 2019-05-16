# Version 0.1
 
# 基础镜像
FROM ubuntu:16.04
 
# 维护者信息
MAINTAINER ch <chenhui896@qq.com>

# 设置ubuntu的镜像，加快速度
RUN echo 'deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial main restricted universe multiverse' > /etc/apt/sources.list \
&& echo 'deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse' >> /etc/apt/sources.list \
&& echo 'deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse' >> /etc/apt/sources.list \
&& echo 'deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-security main restricted universe multiverse' >> /etc/apt/sources.list

# 安装Apache2、php5.6服务并清理缓存
RUN apt-get -y update \
    && apt-get install -y software-properties-common python-software-properties vim supervisor apache2 \
    && LC_ALL=C.UTF-8 add-apt-repository -y -u ppa:ondrej/php \
    && apt-get -y install php5.6 libapache2-mod-php5.6 php5.6-mysql php5.6-mcrypt php5.6-mbstring php5.6-gd \
    && ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 设置 supervisor
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# 拷贝apache2配置文件
COPY apache2.conf /etc/apache2/apache2.conf

# 设置服务环境变量
ENV HOSTNAME localhost
# ENV APACHE_RUN_USER www-data
# ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2

# 修改系统时区
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 设置工作目录
WORKDIR /var/www/html/

# 开放80端口
EXPOSE 80

# 容器启动命令
CMD ["/usr/bin/supervisord"]
