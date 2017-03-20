[![Code Climate](https://codeclimate.com/github/18F/micropurchase/badges/gpa.svg)](https://codeclimate.com/github/18F/micropurchase) [![Test Coverage](https://codeclimate.com/github/18F/micropurchase/badges/coverage.svg)](https://codeclimate.com/github/18F/micropurchase/coverage) [![Dependency Status](https://gemnasium.com/18F/micropurchase.svg)](https://gemnasium.com/18F/micropurchase) [![security](https://hakiri.io/github/18F/micropurchase/master.svg)](https://hakiri.io/github/18F/micropurchase/master)
[![Accessibility](https://continua11y.18f.gov/18F/micropurchase.svg?branch=develop)](https://continua11y.18f.gov/18F/micropurchase)

# Micro-purchase

This is a web application used to manage the bidding process for 18F's
[micro-purchase threshold
experiment](https://18f.gsa.gov/2015/10/13/open-source-micropurchasing/). The
platform will allow vendors to bid on open opportunities with 18F, track their
bids, and learn of the winning bidder. So long as vendors are registered on
[SAM.gov](https://www.sam.gov) and have GitHub accounts, they will be able to
view open opportunities and bid on them.

With this application, a vendor will be able to view the full list of open
micro-purchasing opportunities, access bid histories, and place bids on services
requested by 18F. All bids will start under $3,500 and each project will specify
the desired product and method of delivery.

This is a Ruby/Rails application using ActiveRecord and PostgreSQL. This repo
contains the front end of a web app that integrates GitHub and SAM.gov. For more
information on setting up the back end of the web app, see below.

* Staging: https://micropurchase-staging.18f.gov/
* Production: https://micropurchase.18f.gov/
* API docs: https://micropurchase.18f.gov/api
* [Problem statement](https://docs.google.com/a/gsa.gov/document/d/125NY6oXBOdlL7gDiHFQ5Aog5FEjoddbZVVCeYCz6d9A/edit?usp=sharing)
* [Roadmap](https://18f.storiesonboard.com/m/18f-micro-purchase-platform)
* [Leads tracker](https://trello.com/b/YoEbAui9/micropurchase-leads)
* [Backlog](https://waffle.io/18F/micropurchase)

[![Throughput Graph](https://graphs.waffle.io/18F/micropurchase/throughput.svg)](https://waffle.io/18F/micropurchase/metrics/throughput)

## Documentation

## Local Development

See the [CONTRIBUTING.md](CONTRIBUTING.md) for a full run-down of how to
contribute to this application.

### Database Schema

We are keeping a version-controlled Entity Relationship Diagram (ERD) located
in`docs/erd.pdf`. Any new change to the database schema must include an update
to this diagram. You can automatically update the diagram by running (follow the
local development instructions below if you don't have the app setup locally):

```
[docker-compose run web] bundle exec erd
```

Updating the ERD requires Graphiz. Installation instructions are
[here](http://voormedia.github.io/rails-erd/install.html).

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
