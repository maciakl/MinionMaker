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

  def test_json_with_1
    get '/json/1'
    assert last_response.ok?
    response = JSON.parse(last_response.body)
    assert_equal 1, response.count
  end

  def test_json_with_0
    get '/json/0'
    assert last_response.ok?
    response = JSON.parse(last_response.body)
    assert_equal 0, response.count
  end

  def test_json_with_100
    get '/json/100'
    assert last_response.ok?
    response = JSON.parse(last_response.body)
    assert_equal 50, response.count
  end

  def test_json_naked
    get '/json'
    assert_equal 404, last_response.status
  end

  def test_json_with_alphanumeric
    get '/json/abcd'
    assert_equal 404, last_response.status
  end
end