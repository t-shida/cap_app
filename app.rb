require 'sinatra'
require 'sinatra/config_file'

config_file 'config.yml'

get '/' do
  erb :index
end
