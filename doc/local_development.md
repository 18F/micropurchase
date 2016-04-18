## Local Development

### Setting up and running the app

The application is running Ruby 2.2.3 and Rails 4.2.4. Most of the
libraries are available as gems.

Testing with javascript and capybara on Travis CI requires some
[Poltergeist](https://github.com/teampoltergeist/poltergeist).

You can install poltergeist with homebrew via `brew install phantomjs`

```
$ git clone git@github.com:18F/micropurchase.git
$ cd micropurchase
$ ./script/bootstrap
$ foreman start -p 3000
```

### Setting up GitHub OAuth

To set up GitHub authentication for creating user accounts and logging in, set
up a [new developer application](https://github.com/settings/applications/new).
The "Application name" and "Homepage URL" can be whatever you'd like, but the
"Authorization callback URL" should be `http://localhost:3000`.

Once you register the application, you'll receive a Client ID and a Client
Secret. Put the values in the `.env` file at the root of the application.

```
# .env

MPT_3500_GITHUB_KEY="your-client-id"
MPT_3500_GITHUB_SECRET="your-client-secret"
```

Make sure to restart the server to register those environmental variables.

### Using Docker

A development instance of the Micropurchase application can be spun up quickly
using [Docker Compose](https://docs.docker.com/compose/).

#### Setup

1. [Install docker-compose](https://docs.docker.com/compose/install/).

2. If you're using `boot2docker` (e.g., on OSX), start up `boot2docker`
    (`boot2docker init` and then `boot2docker up`), then get the local IP address
    of the VM with `boot2docker ip`. The output of this will be the local URL you'll
    access. So if the IP is `192.168.59.103/`, you'll access the site locally at
    `http://192.168.59.103:3000`.

3. Update the GitHub application callback URLs to use the IP address (start
   [here](https://github.com/settings/developers)).

After setting your Github application credentials in your `.env` file as
described above, start up the database and application server using
`docker-compose`.

#### Running

It's as simple as:

```
$ docker-compose up
```

And visiting `[the IP from boot2docker IP]:3000`.

The sample data will be populated in the database automatically.

To run the tests:

```
$ docker-compose run web bundle exec rake spec
```

You should be able to run any Rails command by prepending it with `docker-compose run web`.

### Testing

This application uses RSpec for testing models and controllers and Cucumber for
functional testing. These can be run separately like if you'd like to only focus
on one aspect of testing.

```
bundle exec rake spec
bundle exec rake cucumber
```

The default rake task will run both in order

```
bundle exec rake
```
