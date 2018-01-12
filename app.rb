require 'sinatra'
require 'sinatra/config_file'

config_file 'config.yml'

get '/' do
  erb :index
end

get '/core.css' do
  content_type 'text/css', charset: :utf8
  scss :core
end
