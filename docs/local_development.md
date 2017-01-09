## Local Development

### Setting up and running the app

The application is running Ruby on Rails.

The current Ruby version is included in the [`.ruby-version`](../.ruby-version)
file. If you do not have on already, you should install and manage Ruby versions
using a Ruby version manager.  The [18F laptop
script](https://github.com/18F/laptop) installs RVM for this reason.

Testing with javascript and capybara on Travis CI requires some
[Poltergeist](https://github.com/teampoltergeist/poltergeist).

You can install poltergeist with homebrew via `brew install phantomjs`

```
$ git clone git@github.com:18F/micropurchase.git
$ cd micropurchase
$ bin/setup
$ foreman start
```

The app will now be up and running at
[http://localhost:3000/](http://localhost:3000/)

### Setting up GitHub OAuth

To set up GitHub authentication for creating user accounts and logging in, set
up a [new developer application](https://github.com/settings/applications/new).
The "Application name" and "Homepage URL" can be whatever you'd like, but the
"Authorization callback URL" should be `http://localhost:3000`.

Once you register the application, you'll receive a Client ID and a Client
Secret. Put the values in the `.env` file at the root of the application.

```
# .env

MICROPURCHASE_GITHUB_CLIENT_ID="your-client-id"
MICROPURCHASE_GITHUB_SECRET="your-client-secret"
```

Make sure to restart the server to register those environment variables.

### Setting up and testing SAML OAuth

SAML OAuth is currently available for admin users only.

To test SAML OAuth locally, run the [Login.gov
IDP](https://github.com/18F/identity-idp) at port 3004.

### Understanding / viewing transactional emails

We are using [Mandrill](https://mandrillapp.com/) to send transactional emails.
To set up email sending in a production environment, you will need to set the
`MICROPURCHASE_SMTP_SMTP_PASSWORD` and `MICROPURCHASE_SMTP_SMTP_USERNAME`
environment variables.

In the development environment, we are using
[Letter Opener](https://github.com/ryanb/letter_opener). Letter Opener lets you
preview email in the default browser instead of sending it.  This means you do
not need to set up email delivery in your development environment, and you no
longer need to worry about accidentally sending a test email to someone else's
address.

To view sent emails locally, visit http://localhost:3000/letter_opener

### Set up your account to enable bidding locally

To bid in your local environment, you'll first need to log in so there is a
`User` record for you in the database. Then you can run the following:

```
$ rails c
$ user = User.last
$ user.update(sam_status: :sam_accepted)
```

You should now see the "Bid" button on open auctions in your dev environment.

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

#### Using Docker

```
docker-compose up -d
docker-compose run web bundle exec rake spec
```
