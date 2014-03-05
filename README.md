# G5 Authentication Client #

A client library for the g5-authentication service.

## Installation ##

You will need the g5 private gem server at gemfury as a gem source.

In Gemfile:

    gem 'g5_authentication_client'

Just rubygems:

    gem install g5_authentication_client

## Configuration ##

### Environment variables ###

You can set the default value for several configuration settings via
environment variable:

* `G5_AUTH_CLIENT_ID` - the OAuth 2.0 application ID from the auth server
* `G5_AUTH_CLIENT_SECRET` - the OAuth 2.0 application secret from the auth server
* `G5_AUTH_REDIRECT_URI` - the OAuth 2.0 redirect URI registered with the auth server
* `G5_AUTH_ENDPOINT` - the endpoint URL for the G5 auth server

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

## Examples ##

Assuming you have an account on g5-authentication already. Register your client
application and gather the client_id, client_secret, redirect_uri, and generate
an authorization code.

    G5AuthenticationClient.configure do |config|
      config.client_id = "blah"
      config.client_secret = "blah"
      config.redirect_uri = "blah"
      config.endpoint = "blah"
      config.authorization_code = "blah"
    end

    client=G5AuthenticationClient::Client.new

    user=client.create_user({email: 'foo@bar.com', password: 'yadayada'})

    user.email="something@else.com"
    client.update_user user.to_hash

    client.get_user user.id

    client.delete_user user.id

    client.me

    client.token_info

## Contributing

1. Fork it
2. Get it running
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Write your code and **specs**
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request

If you find bugs, have feature requests or questions, please
[file an issue](https://github.com/g5search/g5_authentication_client/issues).

## License

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
