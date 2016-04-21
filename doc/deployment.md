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

### To deploy a new instance of the app

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
