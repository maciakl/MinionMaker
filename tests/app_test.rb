ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'purdytest'
require 'rack/test'
require 'haml'
require_relative '../app'

class MainAppTest < Minitest::Test
  include Rack::Test::Methods 

  def app
    Sinatra::Application
  end

  def test_displays_main_page
    get '/'
    assert last_response.ok?
    assert last_response.body.include?('Minion Academy')
  end

end
