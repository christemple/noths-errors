require 'sinatra'

get '/' do
  'hello world'
end

Sinatra::Application.run!
