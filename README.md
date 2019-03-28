# testrunner-base-ruby

A basic Ruby + Rspec testrunner docker image that holds common infrastructure I
keep using in various projects.

Note this is a heavily opinionated docker image, and I built it primarily for my
personal use. Contributions are welcome but please keep in mind I'm not trying
create a flexible, shareable tool here. :)

## Test

To run your specs in parallel:

```sh
docker run --rm -it mycargus/testrunner-base-ruby bundle exec rspec-queue spec
```

To run the tests in sequence:

```sh
docker run --rm -it mycargus/testrunner-base-ruby bundle exec rspec spec
```

### wait-for

Often I need to wait for dependent Docker containers to accept incoming
connections on a specified port, i.e. the containers have finished "spinning
up," before I can execute the tests. A common example is Postgres. To address
this need I've created the `wait-for` utility.

For example, let's say you need to wait for a Postgres and Web container before
running your tests:

```sh
set -e

docker run --rm mycargus/testrunner-base-ruby wait-for \
  postgres:5432 \
  web:8080

docker run --rm mycargus/testrunner-base-ruby bundle exec rspec
```

`wait-for` attempts to connect to `postgres:5432` and `web:8080` every 1 second
until either both services are ready or the utility times out (default 30
seconds). In the above script, if Postgres and Web aren't both ready after 30
seconds or less then the RSpec tests won't run and the script will `exit 1`.

See `bin/wait-for` for details and options.

## Develop

`testrunner-base-ruby` comes with a few prepackaged tools.

### rubocop

We lint our Ruby with Rubocop. If you want to quickly auto-correct any
violations then we have a handy script for that. You can use it like so:

```sh
docker run --rm mycargus/testrunner-base-ruby rubocop
```

See `bin/rubocop` for details.

### Debug

While writing tests you may need to view the HTTP requests the tests send to
other services. We're using the `airborne` gem and it uses the `rest-client` gem
under the hood to send HTTP requests.

The easiest way to view the `rest-client` HTTP logs is to send them to STDOUT:

```sh
docker run --rm mycargus/testrunner-base-ruby \
  -e RESTCLIENT_LOG=stdout \
  bundle exec rspec
```

Run that ^ and you'll see plenty of info for each HTTP request and response.

#### The byebug gem

We autoload this gem. Just insert a `byebug` statement into your code and you're
good to go.

#### The pry gem

We autoload this gem. Just insert a `binding.pry` statement into your code and
you're good to go.

Pry is a powerful runtime developer console and IRB alternative for Ruby. We
added a few useful Pry plugins to this project. Check out our `.pryrc` config
file to learn a couple of tricks. Click the links below for more info.

[pry](https://github.com/pry/pry)
[pry-byebug](https://github.com/deivid-rodriguez/pry-byebug)
[pry-doc](https://github.com/pry/pry-doc)
[pry-state](https://github.com/SudhagarS/pry-state)

### Add a Ruby Gem

To add a Ruby gem, first build the image without your proposed changes:

```sh
docker build . -t mycargus/testrunner-base-ruby:latest
```

Then modify the Gemfile. Now you can generate the new Gemfile.lock:

```sh
docker run --rm -v "$PWD:/usr/src/app" mycargus/testrunner-base-ruby:latest \
  bundle install
```

Finally, to use your changes you must re-build the Docker image:

```sh
docker build . -t mycargus/testrunner-base-ruby:latest
```

This may seem like the hard way to add a dependency, especially compared to
simply running `bundle install` in your terminal outside of Docker. The reason
we recommend this approach is to make sure we're preserving the same Ruby
version and Bundler version when specifying project dependencies.

### Update a Ruby Gem

Similar to adding a Ruby gem.

Build the image:

```sh
docker build . -t mycargus/testrunner-base-ruby:latest
```

Now update the desired Ruby gem:

```sh
docker run --rm -v "$PWD:/usr/src/app" mycargus/testrunner-base-ruby:latest \
  bundle update --conservative <gem_name>
```

The `--conservative` flag prevents shared dependencies from getting updated. Now
that you've updated the Gemfile.lock, you must re-build the Docker image:

```sh
docker build . -t mycargus/testrunner-base-ruby:latest
```

## Run this project's tests

```sh
docker run --rm -it -v "$PWD:/usr/src/app" \
  mycargus/testrunner-base-ruby:latest test
```

# License

MIT license. Copyright (c) 2019 Michael Hargiss.

See LICENSE for details.
