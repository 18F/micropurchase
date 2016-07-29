## Onboarding

The following instructions are for 18F developers working on this project. This
document should contain all steps required to get up and running on
Micro-purchase.

### Join the Slacks

Join the Micro-purchase Slack channels:

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

18F's [deployments](http://12factor.net/codebase) of Micro-purchase live in AWS,
and are deployed via [Cloud Foundry](http://www.cloudfoundry.org). See [the 18F
Cloud Foundry documentation](https://docs.cloud.gov) for more details on how to
inspect and configure them.

Once you're set up with Cloud Foundry, ask for access to the `18f-acq`
organization in the Micro-purchase Slack channel.

Read more about deployments in the [deployment docs](deployment.md).

### Get set up on New Relic

The existing team members all have access to New Relic monitoring for staging
and production. Ask to be added to the Micro-purchase New Relic organization.

Once added, developers should also add themselves to the "Micropurchase devs"
group on New Relic: <https://rpm.newrelic.com/accounts/1345535/notification_channels>

New Relic is set up to send alerts to everyone in this group by default.

### Start working on a feature

We use Waffle.io to categorize and prioritize our backlog. Visit our [Waffle
board](https://waffle.io/18F/micropurchase) and see the "Ready" swimlane for
features that are ready to be worked on.

Once you've selected a story, assign it to yourself and move it to "In Progress"
so others know that you are working on it.
