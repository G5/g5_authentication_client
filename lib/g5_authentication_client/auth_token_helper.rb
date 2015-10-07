module G5AuthenticationClient::AuthTokenHelper
  # Return response to 'yield'
  # Yield response should have a 'code' method for the http status code
  def do_with_username_pw_access_token
    response = yield cached_username_pw_access_token
    if 401 == response.code.to_i
      @cached_username_pw_access_token = nil
      response                         = yield cached_username_pw_access_token
    end
    response
  end

  def cached_username_pw_access_token
    @cached_username_pw_access_token ||= G5AuthenticationClient::Client.new.username_pw_access_token
  end
end