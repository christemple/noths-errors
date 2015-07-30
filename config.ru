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
  #Raygun.io
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

  #Honeybadger.io
  #{
  #  "event":"occurred",
  #  "message":"[Crywolf/test] RuntimeError - oops",
  #  "fault":{
  #    "id":3151009,
  #    "project_id":1717,
  #    "klass":"RuntimeError",
  #    "component":null,
  #    "action":null,
  #    "environment":"development",
  #    "resolved":true,
  #    "ignored":false,
  #    "created_at":"2014-01-08T18:55:48Z",
  #    "comments_count":1,
  #    "message":"oops",
  #    "notices_count":9,
  #    "last_notice_at":"2014-01-08T19:02:21Z"
  #  }
  #}

  logger.info("#{request.request_method} #{request.path} from #{request.referrer}")
  error = JSON.parse(request.body.read)
  mongo[:errors].insert_one(error)
  status 200
  ''
end

Sinatra::Application.run!
