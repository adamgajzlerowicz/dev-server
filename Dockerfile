FROM  jumpscale/ubuntu1510
RUN rm /var/lib/apt/lists -rf
RUN rm /var/cache/apt/archives/partial -rf
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y ca-certificates git-core ssh curl apache2 php5 vim libapache2-mod-php5 php5-mcrypt php5-mysql php5-xdebug mysql-client php5-curl php5-gd php-pear php5-mcrypt php5-sqlite

RUN rm -rf /var/www/*
RUN a2enmod rewrite
RUN chown -R www-data:www-data /var/www
RUN rm /etc/php5/apache2/php.ini
ADD ./vm/php/php.ini /etc/php5/apache2/php.ini
RUN rm /etc/apache2/sites-available/ -rf
ADD /vm/apache/sites-available /etc/apache2/sites-available

#Fixes empty home
ENV HOME /root
#ADD ssh/ /root/.ssh/

RUN curl -sS https://getcomposer.org/installer | php
RUN ln -s /usr/bin/pear /usr/share/pear
RUN php5enmod mcrypt
RUN a2ensite sme.conf
RUN a2ensite swb.conf
RUN a2enmod rewrite
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
RUN apt-get install php5-xmlrpc -y
RUN apt-get install libxext6* -y
EXPOSE 80

RUN ln -sf /dev/stderr /var/log/apache2/error.log

CMD /usr/sbin/apache2ctl -D FOREGROUND

