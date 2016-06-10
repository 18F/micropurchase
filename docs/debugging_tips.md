## Debugging tips

### Cannot find ENV Vars on Production Environment

Some [environment
 variables](http://guides.rubyonrails.org/configuring.html#rails-environment-settings)
are set automaically via the `env` section of [`manifest.yml`](../manifest.yml)
(or [`manifest-staging.yml`](../manifest-staging.yml) if you are deploying to
staging).

You can see the available enviroment variables by running the following:

```bash
 cf target -p 18f-acq -s staging
 cf env micropurchase-staging
```

The output will contain a `User-Provided` section where you will see the `ENV`
vars set in the manifest file used for deployment.

You can also set environment variables manually via the command line, but
setting them via the manifest file is preferred.

If an environment variable has a sensitive value (eg: auth tokens), we do not
want them exposed by putting them in the manifest files, which are available to
anyone via GitHub. Instead, we user user-provided services. You can learn more
about setting env vars with user-provided serivices in the [deployment
docs](deployment.md##setting-environment-variables-on-staging-or-production).

If you do not see a desired environment variable in the production environment,
make sure you inspect the `user-providedf` hash within the `VCAP_SERVICES` hash
output from running the above commands. As is explain in th deployment docs, we
are using a special buildback that looks at the values in `user-provided` hash
and constructs environment variables based on the `name` and `credentials`
fields. Here is an example of some output you might see when running `cf env`:

```ruby
"VCAP_SERVICES": {
  "user-provided": [
    {
      "credentials": {
        "api_key": "test_api_key"
      },
      "label": "user-provided",
      "name": "data-dot-gov",
      "syslog_drain_url": "",
      "tags": []
    }
  ]
}
```
The data above creates the environment variable `DATA_DOT_GOV_API_KEY` with a
value of `"test_api_key"`.

### GitHub OAuth Not Working

If you are trying to log in via GitHub and are redirected to a URL that looks
like this:
  https://micropurchase-staging.18f.gov/auth/failure?message=csrf_detected&strategy=github,
here are so tips on how to fix the problem.

This issue happens when the `state` param that is sent to GitHub and the `state`
param that is returned do not match. People frequently see this issue when two
requests are going to OAuth. In that case, the `state` for the first request does
not match the `state` for the second request, so OAuth thinks that a third party
has tampered with the request and returns a [CSRF
error](https://github.com/intridea/omniauth-oauth2/blob/26152673224aca5c3e918bcc83075dbb0659717f/lib/omniauth/strategies/oauth2.rb#L71).

One potential cause of this error is multiple Cloud Foundry applications
pointing at the same URL. If you see an OAuth `CSRF`-related error, run the
following:

```bash
cf apps
```

The output should show you infrmation about which apps are in your current Cloud
Foundry space. There is a `urls` section for each application. If there is more
than one application pointing to the same URL, this is likely a mistake.

When you are sure that one of the applications is not needed, you can delete it
and that should fix the OAuth CSRF error described above.
