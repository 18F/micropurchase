## Onboarding

The following instructions are for 18F developers working on this project. This
document should contain all steps required to get up and running on
Micro-purchase.

### Join the Slacks

Join the Micro-purchase Slack channels:

* `#micropurchase` for general discussion
* `#micropurchase-dev` for dev-related discussion
* `#micropurchase-design` for design-related discussion
* `#micropurchase-bizdev` for businessy discussion

### Add yourself as an Admin

[Find your GitHub ID](http://caius.github.io/github_id/) and [add yourself as an
admin](../config/admins.yml).

Being an admin means you can:
* create/edit auctions
* read users
* view bids when auctions are available (this info is veiled/sealed when the
auctions are running)

Don't forget to submit a pull request! See
[CONTRIBUTING.md](../CONTRIBUTING.md) for more information on how this team submits
/ accepts pull requests.

### Get deploy access

18F's [deployments](http://12factor.net/codebase) of Micro-purchase live in AWS,
and are deployed via [Cloud Foundry](http://www.cloudfoundry.org). See [the 18F
Cloud.gov documentation](https://docs.cloud.gov) for more details on how to
inspect and configure them.

Once you're set up with Cloud.gov, ask your fellow developers to [add you as a
SpaceDeveloper for the staging and
production spaces](https://docs.cloud.gov/apps/managing-teammates/#give-roles-to-a-teammate).

Read more about deployments in the [deployment docs](deployment.md).

### Get set up on New Relic

The existing team members all have access to New Relic monitoring for staging
and production. Ask in Slack to be added to the Micro-purchase New Relic organization.
Jacob Harris, Alan DeLevie, and Jessie Young are admins and can add you.

Once added, developers should also add their email address as a notification
channel for the "Default" alert policy. This will ensure that all developers
receive an email when the error percentage goes above .01%.

To add yourself, visit the "Alerts" area in New Relic. Then view "Alert Policies",
select "Default" and view the "Notification Channels". There you will see a
link to add a new channel, which will include a "Users" section where you can
add your User account's email as a recipient of notifications.

### Start working on a feature

We use Waffle.io to categorize and prioritize our backlog. Visit our [Waffle
board](https://waffle.io/18F/micropurchase) and see the "Ready" swimlane for
features that are ready to be worked on.

Once you've selected a story, assign it to yourself and move it to "In Progress"
so others know that you are working on it.
