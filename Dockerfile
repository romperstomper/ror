FROM openshift/base-centos7
USER root
ENV PATH="/usr/local/rvm/rubies/ruby-2.6.3/bin:/usr/local/rvm/bin:${PATH}"
RUN yum update -y
RUN yum install -y epel-release && \
    yum install -y nodejs && \
    yum install -y npm
RUN npm install -y yarn
RUN command curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
RUN command curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
RUN curl -sSL https://get.rvm.io | bash -s stable
RUN rvm install 2.6.3
RUN rvm use 2.6.3
RUN gem install rails
RUN useradd gary
RUN mkdir /opt/app && \
    chown -R gary /opt/app /opt/app-root/src /usr/local/rvm
WORKDIR /opt/app

USER gary
RUN rails new planter
RUN cd planter
RUN rails generate scaffold person email name
RUN rails server
CMD ["sleep", "infinity"]
