# MPT3500

This app will be used to manage bids for 18F's [micro-purchase threshold experiment](https://18f.gsa.gov/2015/10/13/open-source-micropurchasing/). Vendors will be able to view open issues and bid on them, given they have GitHub accounts and are registered on [SAM.gov](https://www.sam.gov).

This is a Ruby/Sinatra application using ActiveRecord and PostgreSQL.

## Local Development

Clone the repo and `cd` into it. Run `bundle` to install gems and install Ruby 2.2.3 if necessary.

Obtain the key and secret of a GitHub application. Set them to the following environment variables:

`MPT_3500_GITHUB_KEY` and `MPT_3500_GITHUB_SECRET`.

To start the local server run `rackup`.

### Testing

```
bundle exec rspec
```

## Deployment

This application is deployed on the cloud.gov PaaS which runs on Cloud Foundry. The following instructions are 18F-specific, but could easily be adapted for other Cloud Foundry instances or other web hosts.

Create the app (it's ok if the deploy fails):

```
$ cf push
```

Create the database service:

```
$ cf create-service rds shared-psql micropurchase
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
>>>>>>> Getting Cloud Foundry set up.

## Public domain

This project is in the worldwide [public domain](LICENSE.md). As stated in [CONTRIBUTING](CONTRIBUTING.md):
ra
> This project is in the public domain within the United States, and copyright and related rights in the work worldwide are waived through the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).
>
> All contributions to this project will be released under the CC0 dedication. By submitting a pull request, you are agreeing to comply with this waiver of copyright interest.
