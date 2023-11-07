FROM ruby:3.2.2

# yarn install
#RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
#    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && \
    apt-get install -y build-essential libpq-dev nodejs npm vim default-mysql-client cron && \
    npm install n -g && \
    n 16.0.0 && \
    service cron start && \
    gem install rails

WORKDIR /src

ADD ./Gemfile /src/Gemfile
ADD ./Gemfile.lock /src/Gemfile.lock
RUN bundle install
