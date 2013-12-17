# Require config/environment.rb
require ::File.expand_path('../environment',  __FILE__)

set :app_file, __FILE__

configure do
  # Set the views to 
  set :views, File.join(Sinatra::Application.root)

  # See: http://www.sinatrarb.com/faq.html#sessions
  enable :sessions
  set :session_secret, ENV['SESSION_SECRET'] || 'this is a secret shhhhh'
end

run Sinatra::Application
