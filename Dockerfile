FROM ruby:2.7.2-buster

LABEL name="LHPC" \
      version="1.0.0"

# PostgreSQL
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - "https://www.postgresql.org/media/keys/ACCC4CF8.asc" | apt-key add -

#Yarn
RUN wget --quiet -O - "https://dl.yarnpkg.com/debian/pubkey.gpg" | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

#Nodejs
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -

RUN  echo "Install packages" \
  && export DEBIAN_FRONTEND=noninteractive \
  && export APT_MIRROR=au.archive.ubuntu.com \
  && if [ -n "$APT_MIRROR" ]; then sed -i'' "s/archive.ubuntu.com/$APT_MIRROR/g" /etc/apt/sources.list; fi \
  && apt-get -y update \
  && apt-get install -qq -y \
      build-essential \
      postgresql-client-12 --fix-missing --no-install-recommends \
      libpq-dev \
      nodejs \
      yarn \
  && echo "Setup timezone" \
  && ln -sf /usr/share/zoneinfo/Pacific/Auckland /etc/localtime \
  && dpkg-reconfigure -f noninteractive tzdata \
  && echo "Create user" \
  && groupadd --gid 1000 appuser \
  && useradd -m --home /home/appuser --uid 1000 --gid appuser --shell /bin/sh appuser \
  && echo "Cleaning up" \
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*

ENV INSTALL_PATH /opt/service
WORKDIR $INSTALL_PATH
RUN chown -R appuser:appuser $INSTALL_PATH
COPY --chown=appuser:appuser Gemfile Gemfile.lock ./

USER appuser
ENV BUNDLE_PATH=/usr/local/bundle/
ENV BUNDLE_APP_CONFIG=/usr/local/bundle/
RUN bundle install
COPY --chown=appuser:appuser . .

EXPOSE 3000
CMD ["./bin/docker-web"]

