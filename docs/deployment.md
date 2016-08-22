## Deployment

### Automated Deployment

Pull requests merged into the `develo` branch will automatically be deployed to
[staging](https://micropurchase-staging.18f.gov).

Pull requests merged into the `master` branch will be automatically deployed to
[production](https://micropurchase.18f.gov).

If you see an error on [Travis CI](https://travis-ci.org/18F/micropurchase)
related to the Cloud.gov password being expired, post in the
`#cloud-gov-support` Slack channel to get the password reset. Then you can
[encrypt the new password](https://docs.travis-ci.com/user/encryption-keys/) and
add it to `.travis.yml`.

### Manual Deployment to Staging or Production

Staging: (live at https://micropurchase-staging.18f.gov/)

```
$ cf target -o 18f-acq -s staging
$ cf push
```

Production (live at https://micropurchase.18f.gov/)

```
$ cf target -o 18f-acq -s production
$ cf push
```

### Setting environment variables on staging or production

Cloud.gov allows you to set environment variables manually, but they are wiped
out by a zero-downtime deploy. To get around this issue, we are accessing
environment variables via `Credentials` classes locally.

The classes pick up environment variables set in the shell by the
`UserProvidedService` module.

If you're not using Cloud Foundry to deploy, just set the environment variables
directly in your system.

Steps to set new environment variables:

1. Create a credentials class for accessing the value. Example:

  ```ruby
  # app/credentials/github_credentials.rb

  class GithubCredentials

    def self.client_id
      ENV['MICROPURCHASE_GITHUB_CLIENT_ID']
    end

    def self.secret
      ENV['MICROPURCHASE_GITHUB_SECRET']
    end
  end
  ```

1. Access the value with the class. Example:

  ```ruby
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider(
      :github,
      GithubCredentials.client_id,
      GithubCredentials.secret,
      scope: "user:email"
    )
  end
  ```

1. If the environment variable is needed to run the application locally, add the
  environment variable to your local `.env` file for local usage. Also add it
  to the `.env.example` file as documentation for other developers.

  ```
  # .env

  MICROPURCHASE_GITHUB_CLIENT_ID=super_secret_key
  MICROPURCHASE_GITHUB_SECRET=super_secret_secret
  ```

  ```
  # .env.example

  MICROPURCHASE_GITHUB_CLIENT_ID=super_secret_key
  MICROPURCHASE_GITHUB_SECRET=super_secret_secret
  ```

1. Create a [user-provided service](https://docs.cloudfoundry.org/devguide/services/user-provided.html):

  ```bash
  $ cf cups micropurchase-github -p "client_id, secret"
  ```

  The above command will interactively prompt you for your GitHub application
  keys. **Important**: do not put quotes around input values. Cloud Foundry will
  do this for you, so if you add a value with quotes it will have double quotes.

  The naming convention strings together and dasherizes the user-provided
  service name and the parameter names to produce environment variables. In the
  example above, we are setting values for `MICROPURCHASE_GITHUB_CLIENT_ID` and
  `MICROPURCHASE_GITHUB_SECRET` env vars ('micropurchase-github' + 'client_id'
  and 'micropurchase-github' + 'secret')

1. Add the service to the manifests:

```
# manifest.yml

services:
- micropurchase-github
```

```
# manifest-staging.yml

services:
- micropurchase-github
```

1. If you want to bind your service to the app before deploying, you can do so
manually.

```bash
$ cf bind-service micropurchase-staging micropurchase-github
```

1. The service keys will automatically be bound to your app and translated into
   environment variables on deploy (which happens via Travis CI).

1. If you want to update the service parameter values, you can update the
   user-provided service:

  ```bash
  $ cf uups micropurchase-github -p 'client_id, secret'
  ```

  The above command will interactively prompt you for your GitHub application
  keys. **Important**: when updating keys and/or values for a user-provided service,
  you must update *all* keys for that service. On update, Cloud Foundry removes
  all previous keys and values from the user-provided service being updated.

### To deploy a new instance of the app

Create the app (it's ok if the deploy fails):

```
$ cf push
```

Create the database service:

```
$ cf create-service rds shared-psql micropurchase-psql
```

Set up the database:

```
$ cf-ssh -f manifest.yml
$~ bundle exec rake db:migrate
$~ bundle exec rake db:seed
```

Restage the app:

```
cf restage micropurchase
```

### Creating / updating C2 API keys

To create keys to use for C2's API (used for creating purchase requests for
auctions that will be paid for with the 18F purchase card), follow these steps:

* Visit https://c2-dev.18f.gov/oauth/applications/
* Create a new application
* Save the Application ID as `MICROPURCHASE_C2_OAUTH_KEY`
* Save the Secret as `MICROPURCHASE_C2_OAUTH_SECRET`
* If you are using a C2 instance other than c2-dev (eg: staging or prod),
  create the application at that base url and save it as `C2_HOST`. For example,
  if you are creating keys for prod, create the keys at
  `https://cap.18f.gov/oauth/applications` and set `C2_HOST` to
  `'https://cap.18f.gov'`
