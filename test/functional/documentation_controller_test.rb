require 'test_helper'

class DocumentationControllerTest < ActionController::TestCase
  test "Getting documentation" do
    get :index
    roles = assigns(:roles)
    assert_equal(roles.length, 2)
    assert_equal(roles[0]["url"], "http://example.com/alpha_url")
    role_data = JSON.parse(roles[0]["model"])
    assert_equal(role_data["name"], "alpha")
    assert_equal(role_data["data"], "alpha data")

    assert_equal(roles[1]["url"], "http://example.com/charlie_url")
    role_data = JSON.parse(roles[1]["model"])
    assert_equal(role_data["name"], "charlie")
    assert_equal(role_data["data"], "charlie data")
  end
end
