## v0.1.5 (2014-03-07)

* Add allow_password_credentials flag to determine whether client instances
* will allow use of username/passwored attributes

## v0.1.4 (2014-03-06)

* Change configure method namespace to g5_auth from g5_authentication_client

## v0.1.1 (2013-11-15)

* Add `G5AuthenticationClient::Client#sign_out_url`. The client should
  redirect to this target URL in order sign out the current user.

## v0.1.0 (2013-11-05)

* Rename all references to `client_callback_url` to `redirect_uri`.
  This is in order to maintain consistency with the terminology used
  in the OAuth 2.0 spec. This is a breaking change for any code written
  against earlier versions of the client.

## v0.0.3 (2013-09-23)

* Add support for retrieving user data based on current credentials
* Add `User#password_confirmation`
* Allow client to configure an OAuth access token directly (thereby
  bypassing the OAuth authorization flow)

## v0.0.2 (2013-07-13)

* Update dependency on modelish to v0.3.x

## v0.0.1

* Initial release
