module G5AuthenticationClient::AuthTokenHelper
  # Return response to 'yield'
  # Yield response should have a 'code' method for the http status code
  def do_with_username_pw_access_token
    begin
      response = yield cached_username_pw_access_token
    rescue RestClient::ExceptionWithResponse => e
      response = e.response
    end
    if response.code.to_i == 401
      @cached_username_pw_access_token = nil
      response                         = yield cached_username_pw_access_token
    end
  end

  def cached_username_pw_access_token
    @cached_username_pw_access_token ||= G5AuthenticationClient::Client.new.username_pw_access_token.token
  end
end
