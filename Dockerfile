FROM ruby:3.1.3

RUN apt-get clean all && apt-get update -qq && apt-get install -y build-essential libpq-dev \
    curl gnupg2 apt-utils  postgresql-client postgresql-server-dev-all git libcurl3-dev cmake \
    libssl-dev pkg-config openssl imagemagick file nodejs npm yarn

WORKDIR /code

COPY Gemfile /code/Gemfile
COPY Gemfile.lock /code/Gemfile.lock

RUN bundle install

COPY startup.sh /usr/bin/
RUN chmod +x /usr/bin/startup.sh

ENTRYPOINT ["startup.sh"]
