# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

FROM centos:centos6

# Configuration environment variables
ENV BUGS_DB_DRIVER mysql
ENV BUGS_DB_USER bugs
ENV BUGS_DB_PASS bugs
ENV BUGS_DB_NAME bugs

ENV ADMIN_EMAIL admin@mozilla.com
ENV ADMIN_PASSWORD password

ENV BUGZILLA_USER bugzilla
ENV BUGZILLA_USER_ID 1000
ENV BUGZILLA_GROUP_ID 1000
ENV WEB_HOME /home/$BUGZILLA_USER/htdocs
ENV BUGZILLA_HOME $WEB_HOME/bmo
ENV BUGZILLA_URL http://localhost:80/bmo/
ENv BUGZILLA_GIT_BRANCH master
ENV BUGZILLA_GIT_URL https://git.mozilla.org/webtools/bmo/bugzilla.git

ENV CPANM cpanm --quiet --notest --skip-installed
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Bugzilla user creation
RUN /usr/sbin/groupadd -g $BUGZILLA_GROUP_ID $BUGZILLA_USER
RUN /usr/sbin/useradd -u $BUGZILLA_USER_ID -g $BUGZILLA_GROUP_ID $BUGZILLA_USER

# System software installation
RUN yum -y install https://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm && yum clean all
RUN yum -y install mysql-community-devel mysql-community-client httpd git \
                   perl-devel tar gzip vim-enhanced gcc gcc-c++ gd-devel \
                   perl-XML-Parser openssl-devel ImageMagick-perl \
                   ImageMagick-devel graphviz mod_perl mod_perl-devel curl \
                   gmp-devel unzip gcc aspell-devel mpfr-devel && yum clean all

# Checkout the Bugzilla code
RUN git clone $BUGZILLA_GIT_URL -b $BUGZILLA_GIT_BRANCH $BUGZILLA_HOME

# Install Perl dependencies
RUN curl -L http://cpanmin.us | perl - --self-upgrade --quiet
RUN cd $BUGZILLA_HOME \
    && $CPANM DBD::mysql \
    && $CPANM Apache2::SizeLimit \
    && $CPANM HTTP::Tiny \
    && $CPANM HTML::TreeBuilder \
    && $CPANM HTML::Element \
    && $CPANM HTML::FormatText \
    && $CPANM XMLRPC::Lite \
#    && $CPANM autodie \
#    && $CPANM IPC::System::Simple \
#    && $CPANM App::Cmd \
#    && $CPAMN Moo \
#    && $CPANM File::Copy::Recursive \
#    && $CPANM Config::General \
#    && $CPANM ElasticSearch \
#    && $CPANM Net::RabbitMQ \
#    && $CPANM Net::SFTP \
#    && $CPANM XML::Simple \
#    && $CPANM Tie::IxHash \
#    && $CPANM Sys::Syslog \
#    && $CPANM Regexp::Common \
#    && $CPANM Crypt::CBC \
#    && $CPANM Crypt::DES \
#    && $CPANM Crypt::DES_EDE3 \
#    && $CPANM Crypt::OpenPGP \
#    && $CPANM Crypt::SMIME \
#    && $CPANM Image::Magick@6.86 \
#    && $CPANM GraphViz \
#    && $CPANM Net::FTP \
#    && $CPANM Net::SFTP \
#    && $CPANM Email::MIME::Attachment::Stripper \
#    && $CPANM Pod::Checker \
#    && $CPANM REST::Client \
#    && $CPANM Test::WWW::Selenium \
#    && $CPANM JSON::RPC::Client \
#    && $CPANM Perl::Tidy \
    && $CPANM --installdeps --with-recommends .

ADD checksetup_answers.txt $BUGZILLA_HOME/checksetup_answers.txt
ADD generate_bmo_data.pl $BUGZILLA_HOME/generate_bmo_data.pl

# Apache configuration
ADD bugzilla.conf /etc/httpd/conf.d/bugzilla.conf

EXPOSE 80

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/sbin/httpd", "-DFOREGROUND"]
