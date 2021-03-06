require 'bundler'
require 'bundler/setup'
require 'sinatra'
require_relative "minionmaker"

minionFactory = MinionFactory.new()

get '/' do
  haml :main
end

get '/random/?' do
  @minions = []
  (1..6).each do @minions << minionFactory.get_minion() end
 haml :index
end

get %r{/json/([\d+]+)/?$} do |number|
  number = Integer(number)
  number = number > 50 ? 50 : number
  output = {}

  if number > 0
    (1..number).each do |i|
      output[i] = minionFactory.get_minion().to_hash
    end
  end

  content_type :json
  output.to_json
end

get '/json/?' do
  haml :json
end

not_found do
  haml :err404
end
