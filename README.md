[![Code Climate](https://codeclimate.com/github/18F/micropurchase/badges/gpa.svg)](https://codeclimate.com/github/18F/micropurchase) [![Test Coverage](https://codeclimate.com/github/18F/micropurchase/badges/coverage.svg)](https://codeclimate.com/github/18F/micropurchase/coverage) [![Dependency Status](https://gemnasium.com/18F/micropurchase.svg)](https://gemnasium.com/18F/micropurchase) [![security](https://hakiri.io/github/18F/micropurchase/master.svg)](https://hakiri.io/github/18F/micropurchase/master)
[![Accessibility](https://continua11y.18f.gov/18F/micropurchase.svg?branch=develop)](https://continua11y.18f.gov/18F/micropurchase)

# Micropurchase

This is a web application used to manage the bidding process for 18F's [micro-purchase threshold experiment](https://18f.gsa.gov/2015/10/13/open-source-micropurchasing/). The platform will allow vendors to bid on open opportunities with 18F, track their bids, and learn of the winning bidder. So long as vendors are registered on [SAM.gov](https://www.sam.gov) and have GitHub accounts, they will be able to view open opportunities and bid on them.

With this application, a vendor will be able to view the full list of open micro-purchasing opportunities, access bid histories, and place bids on services requested by 18F. All bids will start under $3,500 and each project will specify the desired product and method of delivery.

This is a Ruby/Rails application using ActiveRecord and PostgreSQL. This repo contains the front end of a web app that integrates GitHub and SAM.gov. For more information on setting up the back end of the web app, see below.

## Documentation

### Methods and classes

Currently, there is no RDoc-style documentation for the methods and classes in this Rails app. We anticipate fixing this.

### Database Schema

We are keeping a version-controlled Entity Relationship Diagram (ERD) located in`docs/erd.pdf`. Any new change to the database schema must include an update to this diagram. You can automatically update the diagram by running (follow the local development instructions below if you don't have the app setup locally):

```
bundle exec erd
```

Updating the ERD requires Graphiz. Installation instructions are [here](http://voormedia.github.io/rails-erd/install.html).

## Local Development

### Setting up and running the app

The application is running Ruby 2.2.3 and Rails 4.2.4. Most of the
libraries are avalilable as gems.

Testing with javascript and capybara on Travis CI requires some
[Poltergeist](https://github.com/teampoltergeist/poltergeist).

You can install poltergeist via `brew install phantomjs`

```
git clone git@github.com:18F/micropurchase.git
cd micropurchase
bundle install
bundle exec rake db:create:all db:migrate db:test:prepare
bundle exec rake db:seed
foreman start -p 3000
```

### Setting up GitHub OAuth

To set up GitHub authentication for creating user accounts and logging in, set up a [new developer application](https://github.com/settings/applications/new). The "Application name" and "Homepage URL" can be whatever you'd like, but the "Authorization callback URL" should be `http://localhost:3000`.

#### For local development

Once you register the application, you'll receive a Client ID and a Client Secret. Put them into a `.env` file at the root of the application, like this:

```
MPT_3500_GITHUB_KEY="your-client-id"
MPT_3500_GITHUB_SECRET="your-client-secret"
```

Make sure to restart the server to register those environmental variables.

### Using Docker

A development instance of the Micropurchase application can be spun up quickly
using [Docker Compose](https://docs.docker.com/compose/).

#### Setup

1. [Install docker-compose](https://docs.docker.com/compose/install/).

2. If you're using `boot2docker` (e.g., on OSX), start up `boot2docker` (`boot2docker init` and then `boot2docker up`), then get the local IP address of the VM with `boot2docker ip`. The output of this will be the local URL you'll access. So if the IP is `192.168.59.103/`, you'll access the site locally at `http://192.168.59.103:3000`.

3. Update the GitHub application callback URLs to use the IP address (start [here](https://github.com/settings/developers)).

After setting your Github application credentials in your `.env` file as described above, start up the database and application server using `docker-compose`.

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

You should be able to run any Rails command by preprending it with `docker-compose run web`.

#### For deployment

See the GitHub API keys section of our deployment instructions below.

### Testing

This application uses Rspec for testing models and controllers and Cucumber for functional testing. These can be run separately like if you'd like to only focus on one aspect of testing.

```
bundle exec rake spec
bundle exec rake cucumber
```

The default rake task will run both in order

```
bundle exec rake
```

### Coverage and CodeClimate

Because this application uses two different test suites (RSpec and Cucumber), it has a more complicated setup for measuring coverage and reporting it to CodeClimate. By default, CodeClimate only will use the coverage statistics from RSpec, meaning you will see a drop in coverage for controllers tested more thoroughly by Cucumber. The solution involves a few parts:

1. The `.simplecov` file in the root specifies SimpleCov configuration shared by both RSpec and Cucumber. This switches the coverage gem to use for CI vs. local operation.
2. The [codeclimate_batch](https://github.com/grosser/codeclimate_batch) CLI merges the coverage reports from each suite before reporting to CodeClimate. This process includes sending all configs to the [cc-amend](https://cc-amend.herokuapp.com/) service. To use the them, you must also make sure your CI calls bundler with `--binstubs` to install gem binaries locally.
3. The codeclimate_batch gem will only run on a CI server and you must also define an environment variable `CODECLIMATE_REPO_TOKEN` with the value of the repo token provided by CodeClimate for it to work.
4. The codeclimate_batch gem will also only run on the DEFAULT_BRANCH specified in the `.simplecov` file. If you change your CodeClimate to use a branch other than develop, you must change the value in `.simplecov`

If everything is working correctly, you should see the following text at the bottom of CI builds of your `develop` branch:

``` shell
$ ./bin/codeclimate-batch --groups 2
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 23656  100    41  100 23615    202   114k --:--:-- --:--:-- --:--:--  118k
sent 2 reports for 18F-micropurchase-1248
Code climate: 0.21s to send 2 reports
```

#### Using Docker

```
docker-compose up -d
docker-compose run web bundle exec rake spec
```

## Deployment

This application is deployed on the cloud.gov PaaS which runs on Cloud Foundry. The following instructions are 18F-specific, but could easily be adapted for other Cloud Foundry instances or other web hosts.

Create the app (it's ok if the deploy fails):

```
$ cf push
```

Create the database service:

```
$ cf create-service rds shared-psql micropurchase-psql
```

Create a [user-provided service](https://docs.cloudfoundry.org/devguide/services/user-provided.html):

```
$ cf cups micropurchase-github -p "client_id, secret"
```

The above command will interactively prompt you for your GitHub application keys.

The value stored locally in `MPT_3500_GITHUB_KEY` is the `client_id`.

The value stored locally in `MPT_3500_GITHUB_SECRET` is the `secret.`

Bind your services to the app:

```
$ cf bind-service micropurchase micropurchase-psql
$ cf bind-service micropurchase micropurchase-github
```

Set up the database:

```
$ cf-ssh
$~ bundle exec rake db:migrate
$~ bundle exec rake db:seed
```

Restage the app:

```
cf restage micropurchase
```

### Manual Deployment

```
cf push
```

### Automated Deployment

Pull requests merged into the `master` branch will be automatically deployed to https://micropurchase.18f.gov.

## Security Scans

This repository uses two tools to provide a total of three types of automated security checks:

- [Brakeman](http://brakemanscanner.org/) provides static code analysis.
- [Hakiri](https://hakiri.io/) is used to ensure the Rails/Ruby versions contain no known CVEs.
- Hakiri is used to ensure the gems declared in the Gemfile contain no known CVEs.

All security scans are built into the test suite. `bundle exec rake spec` will run them. To run the security scans ad hoc:

Brakeman:
```
bundle exec brakeman
```

Hakiri for Ruby/Rails versions:
```
bundle exec hakiri system:scan -m hakiri_manifest.json
```

Hakiri for Gemfile dependency versions:
```
bundle exec hakiri gemfile:scan
```

### Ignored Brakeman warnings

Sometimes Brakeman will report a false positive. In cases like these, the warnings will be ignored. Ignored warnings are declared in `config/brakeman.ignore`. This file contains a machine-readable list of all ignored warnings. Any ignored warning will contain a note explaining (or linking to an explanation of) why the warning is ignored.

## Public domain

This project is in the worldwide [public domain](LICENSE.md). As stated in [CONTRIBUTING](CONTRIBUTING.md):

> This project is in the public domain within the United States, and copyright and related rights in the work worldwide are waived through the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).
>
> All contributions to this project will be released under the CC0 dedication. By submitting a pull request, you are agreeing to comply with this waiver of copyright interest.
