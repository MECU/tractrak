FROM ruby:3.0.3-bullseye

# Install NodeJS and Yarn
RUN apt-get update
RUN apt-get -y install curl
RUN apt-get install -my gnupg
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get -qqyy install nodejs yarn && rm -rf /var/lib/apt/lists/*

# Install Ruby Gems and node modules
COPY Gemfile* /tmp/
COPY package.json /tmp/
COPY yarn.lock /tmp/
WORKDIR /tmp

RUN gem install bundler -v 2.2.32
RUN bundle config set --local without 'development test'
RUN bundle install --jobs 5 --retry 5
RUN yarn install

RUN mkdir /app
WORKDIR /app
RUN mkdir -p tmp/pids
COPY . /app
ENV RAILS_ENV production
ENV RACK_ENV production

# Execute the Procfile
CMD ["bin/run-dev.sh"]
