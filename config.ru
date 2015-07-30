require 'sinatra'
require 'mongo'
require 'json'
require 'date'

disable :protection

mongodb_uri = ENV['MONGOLAB_URI'] || 'mongodb://127.0.0.1:27017/nothsErrors'

mongo = Mongo::Client.new(mongodb_uri)

get '/' do
  @errors = mongo[:errors].find.to_a
  erb :index
end

post '/' do
  #honeybadger_error = JSON.parse(request.body.read)
  #error = {
  #    :honeybadger_error_id => honeybadger_error['fault']['id'],
  #    :message => honeybadger_error['message'],
  #    :created_at => DateTime.now
  #}
  error = JSON.parse(request.body.read) # raygun or honeybadger at this point
  mongo[:errors].insert_one(error)
  "Added #{error}"
end

Sinatra::Application.run!
