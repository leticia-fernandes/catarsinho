FROM ruby:2.5.5
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /catarsinho
WORKDIR /catarsinho
COPY Gemfile /catarsinho/Gemfile
COPY Gemfile.lock /catarsinho/Gemfile.lock
RUN bundle install
COPY . /catarsinho

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
