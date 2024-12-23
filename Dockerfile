FROM ruby:3.2

WORKDIR /app

RUN apt-get update -qq && apt-get install -y build-essential

COPY Gemfile Gemfile.lock lol-wrapper.gemspec ./

RUN bundle install

COPY . .

CMD ["bash"]
