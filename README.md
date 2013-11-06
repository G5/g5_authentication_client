# G5 Authentication Client #

A client library for the g5-authentication service.

## Installation ##

You will need the g5 private gem server at gemfury as a gem source.

In Gemfile:

    gem 'g5_authentication_client'

Just rubygems:

    gem install g5_authentication_client

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
