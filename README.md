[![Code Climate](https://codeclimate.com/github/18F/micropurchase/badges/gpa.svg)](https://codeclimate.com/github/18F/micropurchase) [![Test Coverage](https://codeclimate.com/github/18F/micropurchase/badges/coverage.svg)](https://codeclimate.com/github/18F/micropurchase/coverage) [![Dependency Status](https://gemnasium.com/18F/micropurchase.svg)](https://gemnasium.com/18F/micropurchase) [![security](https://hakiri.io/github/18F/micropurchase/master.svg)](https://hakiri.io/github/18F/micropurchase/master)

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

The application is running Ruby 2.2.3 and Rails 4.2.4. Libraries are all
available via gems.

* `bundle` to get your gem dependencies installed
* Talk to someone of the team to get the authentication secret and key
  for the github account we are using for authentication. You will want
to put these variables in your environment: `export
MPT_3500_GITHUB_KEY=the-magic-key-given-you` and `export
MPT_3500_GITHUB_SECRET=another-magic-key`.
* create your test and development databases: `bundle exec rake
  db:create:all db:migrate db:test:prepare`
* start the local server with `bundle exec rails s`


### Testing

```
bundle exec rspec
```
or
```
rake spec
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

Set environment variables with `cf set-env`:

```
$ cf set-env micropurchase MPT_3500_GITHUB_KEY [the key]
$ cf set-env micropurchase MPT_3500_GITHUB_SECRET [the secret]
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
