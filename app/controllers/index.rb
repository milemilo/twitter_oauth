get '/' do
  erb :index
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  redirect request_token.authorize_url
end

get '/sign_out' do
  session.clear
  redirect '/'
end

get '/auth' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  # our request token is only valid until we use it to get an access token, so let's delete it from our session
  session.delete(:request_token)

  # p @access_token

  username = @access_token.params[:screen_name]
  user_id = @access_token.params[:user_id]
  token = @access_token.token 
  secret =  @access_token.secret
  @user = User.find_or_create_by_user_id(user_id: user_id, username: username, oauth_token: token, oauth_secret: secret)

  erb :index
  
end
