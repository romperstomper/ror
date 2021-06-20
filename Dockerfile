FROM openshift/base-centos7
USER root
ENV PATH="/opt/app/node_modules/yarn/bin:/opt/app-root/src/node_modules/yarn/bin:/usr/local/rvm/rubies/ruby-2.6.3/bin:/usr/local/rvm/bin:${PATH}"
WORKDIR /opt/app
RUN yum remove node npm nodesource-release-el7-1
RUN curl -fsSL https://rpm.nodesource.com/setup_14.x | bash -
RUN yum clean all
RUN yum update -y
RUN yum install -y nodejs
RUN npm install -y yarn
RUN command curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
RUN command curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
RUN curl -sSL https://get.rvm.io | bash -s stable
RUN rvm install 2.6.3
WORKDIR /opt/app
RUN useradd --create-home --shell /bin/bash gary
RUN rvm use 2.6.3
RUN gem install rails
RUN mkdir -p /opt/app && \
    chown -R gary /opt/app /opt/app-root/src /usr/local/rvm
EXPOSE 3000
USER gary
RUN rails new planter
WORKDIR /opt/app/planter
RUN rails generate scaffold person email name
RUN cd /opt/app/planter
CMD ["rails", "s"]
