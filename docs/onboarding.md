## Onboarding

The following instructions are for 18F developers working on this project. This
document should contain all steps required to get up and running on
Micropurchase.

### Join the Slacks

Join the Micropurchase Slack channels:

* `#micropurchase` for general discussion
* `#micropurchase-status` for downtime alerts

### Add yourself as an Admin

[Find your GitHub ID](http://caius.github.io/github_id/) and [add yourself as an
admin](../config/admins.yml).

Being an admin means you can:
* create/edit auctions
* read users
* view bids when auctions are running (this info is veiled/sealed when the
auctions are running)

Don't forget to submit a pull request! See
[CONTRIBUTING.md](../CONTRIBUTING.md) for more information on how this team submits
/ accepts pull requests.

### Get deploy access

18F's [deployments](http://12factor.net/codebase) of Micropurchase live in AWS,
and are deployed via [Cloud Foundry](http://www.cloudfoundry.org). See [the 18F
Cloud Foundry documentation](https://docs.cloud.gov) for more details on how to
inspect and configure them.

Once you're set up with Cloud Foundry, ask for access to the `18f-acq`
organization in the Micropurchase Slack channel.

Read more about deployments in the [deployment docs](deployment.md).
