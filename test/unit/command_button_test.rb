require 'json'
require 'test_helper'

class CommandButtonTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "json deserialization" do
    button = command_buttons(:one)
    json_text = button.to_json
    json_object = JSON.parse(json_text)
    assert_equal(1, json_object["id"])
    assert_equal("Do thing 1", json_object["name"])
    assert_equal("puts \"Hello!\"", json_object["command"])
  end
end
