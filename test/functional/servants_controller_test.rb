require 'json'
require 'test_helper'

class ServantsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test "adding servant" do
    servant_1 = {
      "name" => "foo",
      "url" => "http://127.0.0.1"
    }
    raw_post :add_servant, {}, servant_1.to_json
    assert_ok_with_data servant_1
  end

  test "servants must have unique names" do
    servant_1 = {
      "name" => "foo",
      "url" => "http://127.0.0.1"
    }
    servant_2 = {
      "name" => "bar",
      "url" => "http://127.0.0.1"
    }
      
    raw_post :add_servant, {}, servant_1.to_json
    assert_ok_with_data servant_1

    raw_post :add_servant, {}, servant_2.to_json
    assert_ok_with_data servant_2
    
    raw_post :add_servant, {}, servant_1.to_json
    assert_status(500)
    response_json = JSON.parse(@response.body)
    assert_equal("DuplicateRecord", response_json["name"])
  end
end
