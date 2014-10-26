require 'bundler'
require 'bundler/setup'
require 'sinatra'
require_relative "minionmaker"

minionFactory = MinionFactory.new()

get '/' do
  @minions = []
  (0..4).each do @minions << minionFactory.get_minion() end
 haml :index

end
