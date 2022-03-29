FROM ruby:latest

RUN apt-get update
RUN apt-get install -y nodejs

ENV APP_HOME /myapp
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install

ADD . $APP_HOME

EXPOSE 8000
ENTRYPOINT ["rails", "server", "-b", "0.0.0.0", "-p", "8000"]
