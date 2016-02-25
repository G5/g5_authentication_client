# G5 Authentication Client #

A client library for the g5-authentication service.

## Current version ##

0.5.4

## Requirements ##

* Ruby >= 1.9.3

## Installation ##

In Gemfile:

```ruby
gem 'g5_authentication_client'
```

Just rubygems:

```console
$ gem install g5_authentication_client
```

## Configuration ##

### Environment variables ###

You can set the default value for several configuration settings via
environment variable (not all of these will be used concurrently!):

* `G5_AUTH_CLIENT_ID` - the OAuth 2.0 application ID from the auth server
* `G5_AUTH_CLIENT_SECRET` - the OAuth 2.0 application secret from the auth server
* `G5_AUTH_REDIRECT_URI` - the OAuth 2.0 redirect URI registered with the auth server
* `G5_AUTH_ENDPOINT` - the endpoint URL for the G5 auth server
* `G5_AUTH_USERNAME` - the username for the end user to authenticate as
* `G5_AUTH_PASSWORD` - the password for the end user to authenticate as
* `G5_AUTH_ACCESS_TOKEN` - a valid OAuth 2.0 access token (note that tokens do expire)
* `G5_AUTH_ALLOW_PASSWORD_CREDENTIALS` - set to 'true' to use resource owner password credentials grant

### Module-level config ###

Any settings that are configured on the `G5AuthenticationClient` module will
apply to all instances of `G5AuthenticationClient::Client`, unless that setting
is overridden at the client level.

```ruby
G5AuthenticationClient.configure do |config|
  config.client_id = 'blah'
  config.client_secret = 'blah'
  config.redirect_uri = 'blah'
  config.endpoint = 'blah'
  config.debug = true
  config.logger = Rails.logger

  # It would be unusual to configure non-client credentials at the module
  # level, but it is possible. You would only need to configure one of the
  # following:

  # If you already have an OAuth access token
  config.access_token = 'blah'

  # For the OAuth authorization code grant type
  config.authorization_code = 'blah'

  # For the resource owner password credentials grant type
  config.username = 'blah'
  config.password = 'blah'
end
```

### Client-level config ###

To override a setting for a particular instance of `G5AuthenticationClient::Client`
without affecting any other instances, you can pass the configuration option
into the initializer:

```ruby
G5AuthenticationClient.configure do |config|
  config.endpoint = 'https://dev-auth.g5search.com'
end

client = G5AuthenticationClient::Client.new(endpoint: 'http://localhost:3000')
client.endpoint
# => "http://localhost:3000"

client = G5AuthenticationClient::Client.new
client.endpoint
# => "https://dev-auth.g5search.com"
```

## Usage ##

### Retrieving user information ###

Assuming you have a valid access token, set up your client instance:

```ruby
auth_client = G5AuthenticationClient::Client.new(access_token: 'my_token')
```

You can retrieve information for the user associated with the access token:

```ruby
current_user = auth_client.me
# => #<G5AuthenticationClient::User email="my.user@test.host" id=1>
```

You can also retrieve information about any other user by ID:

```ruby
user = auth_client.get_user(42)
# => #<G5AuthenticationClient::User email="another.user@test.host" id=42>
```

You can list all users in the remote service:

```ruby
user = auth_client.list_users
# => [#<G5AuthenticationClient::User email="another.user@test.host" id=42>, ... ]
```

### Retrieving token information ###

You can retrieve information specific to the current access token, including
scopes and expiration time:

```ruby
auth_client = G5AuthenticationClient::Client.new(access_token: 'my_access_token')
token_info = auth_client.token_info
# => #<G5AuthenticationClient::TokenInfo application_uid={"uid"=>"my_application_id"} expires_in_seconds=5183805 resource_owner_id=1 scopes=[]>
```

To retrieve the token value itself:

```ruby
auth_client.get_access_token
# => "my_access_token"
```

### Creating a user ###

To create a user, you need their email and password. You can either pass in
these credentials as an option hash:

```ruby
auth_client = G5AuthenticationClient::Client.new(access_token: 'my_access_token')
user = auth_client.create_user(email: 'new.user@test.host',
                               password: 'testing',
                               password_confirmation: 'testing')
# => #<G5AuthenticationClient::User email="new.user@test.host" id=123>
```

Or you can pass in an instance of `G5AuthenticationClient::User`:

```ruby
user = G5AuthenticationClient::User.new(email: 'new.user@test.host',
                                        password: 'testing',
                                        password_confirmation: 'testing')
auth_client.create_user(user)
```

### Updating a user ###

To update an existing user, you'll need the user ID and the new credentials:

```ruby
auth_client = G5AuthenticationClient::Client.new(access_token: 'my_access_token')
auth_client.update_user(id: 42,
                        email: 'updated.email@test.host',
                        password: 'updated_secret',
                        password_confirmation: 'updated_secret')
```

You can also pass in a `G5AuthenticationClient::User` instance instead:

```ruby
user = auth_client.create_user(email: 'new.user@test.host',
                               password: 'secret',
                               password_confirmation: 'secret')
user.email = 'updated.email@test.host'
auth_client.update_user(user)
```

### Deleting a user ###

To delete a user, you need the user ID:

```ruby
auth_client = G5AuthenticationClient::Client.new(access_token: 'my_access_token')
auth_client.delete_user(42)
```

### Sign-out URL ###

In order to sign out of the G5 auth service from a web browser, your client
application must redirect to the auth server's sign-out URL. You can
pass in a redirect URL for the auth server to redirect back to after the
sign-out process is complete.

```ruby
auth_client = G5AuthenticationClient::Client.new
auth_client.sign_out_url('https://myapp.host/callback')
# => "https://auth.g5search.com/users/sign_out?redirect_url=https%3A%2F%2Fmyapp.host%2Fcallback"
```

### Retrieving user roles ###

A user's assigned roles will be included automatically when you retrieve user
data via `get_user` or `list_users`.

To retrieve a list of all roles (to which you have access) in the G5 auth
service:

```ruby
auth_client = G5AuthenticationClient::Client.new(access_token: 'my_access_token')
auth_client.list_roles
# => [#<G5AuthenticationClient::Role name="admin" type="GLOBAL" urn=nil>,
#     #<G5AuthenticationClient::Role name="viewer" type="G5Updatable::Client" urn="g5-c-1abc2de-custom-client">,
#     ...]
```

## Examples ##

These examples assume that you have already registered your client application
and at least one end user on the auth server.

### Authorization grant ####

You will need the following credentials:

* Client ID
* Client secret
* Redirect URI
* Authorization code

The client ID, client secret, and redirect URI will be the same for any request
your application may make, so you will probably want to configure these either
via environment variables or at the module level:

```ruby
G5AuthenticationClient.configure do |config|
  config.client_id = 'my-client-id'
  config.client_secret = 'my-client-secret'
  config.redirect_uri = 'https://test.host/callback'
end
```

Each authorization code can only be used once, so it's best configured on the
client instance:

```ruby
auth_client = G5AuthenticationClient::Client.new(authorization_code: 'my_one_time_use_code')
```

You can now execute actions against the auth service using that client:

```ruby
auth_client.me
# => #<G5AuthenticationClient::User email="another.user@test.host" id=42>
```

Or you can retrieve an access token in order to authenticate to another G5
service:

```ruby
auth_client.get_access_token
# => "my-g5-access-token-value-abc123"
```

### Resource owner password credentials grant ###

This grant type is only available to highly trusted client applications that
do not require explicit authorization by the end user.

You will need the following credentials:

* Client ID
* Client secret
* Redirect URI
* Username
* Password

Your client credentials will always be the same for every request, so use
module-level configuration or environment variables for those:

```bash
export G5_AUTH_CLIENT_ID='my-client-id'
export G5_AUTH_CLIENT_SECRET='my-client-secret'
export G5_AUTH_REDIRECT_URI='https://test.host/callback'
export G5_AUTH_ALLOW_PASSWORD_CREDENTIALS='true'
```
Warning:  setting G5_AUTH_ALLOW_PASSWORD_CREDENTIALS will cause all client instances
to use the username/password specified in the absence of an access_token.  Usually, this
will be used per instance.

If you want to use a different username and password per request, then you
should configure these on each client instance:

```ruby
auth_client = G5AuthenticationClient::Client.new(username: 'user1@test.host', password: 'secret1')
auth_client.me
# => #<G5AuthenticationClient::User email="user1@test.host" id=1>

auth_client = G5AuthenticationClient::Client.new(username: 'user2@test.host', password: 'secret2')
auth_client.me
# => #<G5AuthenticationClient::User email="user2@test.host" id=2>
```

However, if you want to use the same user credentials for all requests,
you can set them using environment variables:

```bash
export G5_AUTH_USERNAME='user1@test.host'
export G5_AUTH_PASSWORD='secret1'
```

Now every client instance will authenticate as the same user by default:

```ruby
G5AuthenticationClient::Client.new.me
# => #<G5AuthenticationClient::User email="user1@test.host" id=1>

G5AuthenticationClient::Client.new.me
# => #<G5AuthenticationClient::User email="user1@test.host" id=1>
```

## Authors ##

* Rob Revels / [@sleverbor](https://github.com/sleverbor)
* Maeve Revels / [@maeve](https://github.com/maeve)

## Contributing ##

1. Fork it
2. Get it running
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Write your code and **specs**
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request

If you find bugs, have feature requests or questions, please
[file an issue](https://github.com/G5/g5_authentication_client/issues).

### Running the specs ###

All you have to do is execute rspec through bundler:

```console
$ bundle exec rspec spec
```

## License ##

Copyright (c) 2014 G5

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
