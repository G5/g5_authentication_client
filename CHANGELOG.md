## v1.0.1 (2018-01-22)

 * Removing RestClient dependency
 * [#35](https://github.com/G5/g5_authentication_client/pull/35)

## v1.0.0 (2017-10-18)

* **Backwards incompatible changes**
  * Drop support for ruby < 2.2
* Enhancements
  * Upgrade modelish to ensure compatibility with ruby 2.4 and
  rails 5.x
  * opt in to immutable string literals for ruby >= 2.3
* Fixes
  * force modelish upgrade to pick up fixes for hashie 3.x
* See [#33](https://github.com/G5/g5_authentication_client/pull/33)

## v0.5.5 (2017-01-30)

 * RestClient raises errors on 401.
 ([#32](https://github.com/G5/g5_authentication_client/pull/32))

## v0.5.4 (2016-02-25)

* Add support for token `created_at` timestamp
  ([#30](https://github.com/G5/g5_authentication_client/pull/30))

## v0.5.3

* `Client#username_pw_access_token`: raise error when username/password are blank
  ([#29](https://github.com/G5/g5_authentication_client/pull/29))

## v0.5.2

* convenience method for access tokens
  ([#27](https://github.com/G5/g5_authentication_client/pull/27))

## v0.5.1 (2015-08-21)

* Allow user attributes to be selectively updated
  ([#25](https://github.com/G5/g5_authentication_client/pull/25))

## v0.5.0 (2015-06-01)

* Add support for resource-scoped roles
  ([#24](https://github.com/G5/g5_authentication_client/pull/24))

## v0.4.0 (2015-05-20)

* Add `G5AuthenticationClient::Client#list_roles`, a new
  `G5AuthenticationClient::Role` model, and support for retrieving/updating
  roles in the user data
  ([#23](https://github.com/G5/g5_authentication_client/pull/23))

## v0.3.0 (2015-01-08)

* Add `G5AuthenticationClient::Client#list_users`
  ([#22](https://github.com/G5/g5_authentication_client/pull/22))

## v0.2.3 (2014-07-31)

* remove id from body in create/update user

## v0.2.0 (2014-03-10)

* First open source release to [RubyGems](http://rubygems.org/)

## v0.1.5 (2014-03-07)

* Add `allow_password_credentials` flag to determine whether client instances
  will allow use of username/passwored attributes

## v0.1.4 (2014-03-06)

* Change configure method namespace to `g5_auth` from `g5_authentication_client`

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
