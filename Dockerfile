FROM instructure/ruby:2.6

USER root

ENV APP_DIR "/usr/src/app"
ENV PATH "$APP_DIR/bin/:$PATH"

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    netcat=* \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR $APP_DIR

USER docker

COPY --chown=docker:docker Gemfile Gemfile.lock ./

RUN bundle install --quiet --jobs 8

COPY --chown=docker:docker . ./
