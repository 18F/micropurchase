## Deployment

### Automated Deployment

Pull requests merged into the `master` branch will be automatically deployed to
[production](https://micropurchase.18f.gov).

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
out on each deploy. To get around this issue, we are setting environment
variables via `Credentials` classes locally and having those classes access
attributes stored in user-provided services on Cloud.gov.

Steps to set new environment variables:

1. Create a credentials class for accessing the value (env var locally, service in prod env). Example:

  ```ruby
  # app/credentials/github_credentials.rb

  class GithubCredentials
    extend UserProvidedService

    def self.client_id(force_vcap: false)
      if use_env_var?(force_vcap)
        ENV['MPT_3500_GITHUB_KEY']
      else
        credentials('micropurchase-github')['client_id']
      end
    end

    def self.secret(force_vcap: false)
      if use_env_var?(force_vcap)
        ENV['MPT_3500_GITHUB_SECRET']
      else
        credentials('micropurchase-github')['secret']
      end
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

1. Add the environment variable to your local `.env` file for local usage:

  ```
  # .env

  MPT_3500_GITHUB_KEY=super_secret_key
  MPT_3500_GITHUB_SECRET=super_secret_secret
  ```

1. Create a [user-provided service](https://docs.cloudfoundry.org/devguide/services/user-provided.html):

  ```ruby
  $ cf cups micropurchase-github -p "client_id, secret"
  ```

  The above command will interactively prompt you for your GitHub application
  keys. Important: do not put quotes around input values. Cloud Foundry will do
  this for you, so if you add a value with quotes it will have double quotes.

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

```
$ cf bind-service micropurchase-staging micropurchase-github
```

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
$ cf-ssh
$~ bundle exec rake db:migrate
$~ bundle exec rake db:seed
```

Restage the app:

```
cf restage micropurchase
```
