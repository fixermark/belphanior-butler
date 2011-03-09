require 'json'
require 'test_helper'

class ServantsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test "adding servant" do
    raw_post :add_servant, {}, {
      "name" => "foo",
      "url" => "http://127.0.0.1"
    }.to_json
    assert_ok_status
  end

  test "servants must have unique names" do
    assert true
  end
end
