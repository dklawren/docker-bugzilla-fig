# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

FROM centos:centos6

ENV MYSQL_USER bugzilla
ENV MYSQL_USER_ID 1000
ENV MYSQL_GROUP_ID 1000
ENV MYSQL_ROOT_PASSWORD password
ENV BUGS_DB_USER bugs
ENV BUGS_DB_PASS bugs
ENV BUGS_DB_NAME bugs

# Software installation
RUN yum -y install https://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm && yum clean all
RUN yum -y install mysql-community-server mysql-community-devel && yum clean all

ADD my.cnf /etc/mysql/my.cnf
ADD mysql_config.sh /mysql_config.sh
RUN bash /mysql_config.sh

EXPOSE 3306

CMD ["mysqld_safe"]
