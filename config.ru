require 'sinatra'
require 'mongo'
require 'json'

mongodb_uri = ENV['MONGOLAB_URI'] || 'mongodb://127.0.0.1:27017/nothsErrors'

mongo = Mongo::Client.new(mongodb_uri)

get '/' do
  @errors = mongo[:errors].find.to_a.map(&:inspect)
  erb :index
end

post '/' do
  #{
  #  "event":"error_notification",
  #  "error": {
  #    "url":"http://app.raygun.io/error-url",
  #    "message":"",
  #    "firstOccurredOn":"2014-01-28T01:49:36Z",
  #    "lastOccurredOn":"2014-01-28T01:49:36Z",
  #    "usersAffected":1,
  #    "totalOccurrences":1
  #  },
  #  "application": {
  #    "name":"application name",
  #    "url":"http://app.raygun.io/application-url"
  #  }
  #}

  raygun_error = JSON.parse(request.body.read)
  mongo[:errors].insert_one(raygun_error)
  status 200
  ''
end

Sinatra::Application.run!
