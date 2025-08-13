FROM ruby:3.3-slim

RUN apt-get update -y && apt-get install -y --no-install-recommends \
    build-essential libpq-dev git curl libyaml-dev \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app
ENV BUNDLE_JOBS=4 BUNDLE_RETRY=3

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
EXPOSE 3000
CMD ["bash","-lc","bundle exec rails s -p 3000 -b 0.0.0.0"]