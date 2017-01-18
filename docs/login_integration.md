## Login.gov integration

### Background

Currently, existing admin users in the Micro-purchase database can choose to
sign into the site with [Login.gov](https://pages.18f.gov/identity-intro/). This
document will explain how to get set up to test this sign in functionality on
the Micro-purchase staging site.

### Requirements

* If you haven't already, [add yourself as an
  admin](onboarding.md#add-yourself-as-an-admin).
* Sign in as an admin by visiting https://micropurchase-staging.18f.gov/ (this creates a user account in the database).

### Steps to test Login.gov authentication on staging

* Once you have signed in normally as an admin, you can see the email address
  supplied by GitHub by viewing [your
  profile](https://micropurchase-staging.18f.gov/account/profile) while signed in.
* Sign out of the application by clicking the "Logout" link.
* Visit the [admin sign in
  page](https://micropurchase-staging.18f.gov/admin/sign_in)
* Click on the "Login.gov" logo
* You will be redirected to the [Identity IDP dev
  application](https://idp.dev.login.gov/). If you already have an account, you
  can sign in with your email and password. Otherwise, click on the "Create
  account" link and go through the account creation flow. *Note*: You must sign
  in with the same email address that you saw on your Micro-purchase profile
  page.
* Once you complete the sign in or sign up process, you will be signed in and
  redirected back to the admin section of the Micro-purchase application.
* If you attempt to sign in with a Login.gov account that uses a different email
  address, you will be redirected back to the Micro-purchase application with a
  message notifying you that there was no admin account found.
* Once you log in successfully, you can log out via clicking the "Logout" link.
* To confirm that you were signed out of both the Micro-purchase application and
  the IDP application, visit the [Identity IDP dev home page](https://idp.dev.login.gov/) and
  confirm that you are signed out.

### Steps to test Login.gov authentication on production

This feature has not been deployed to production.
