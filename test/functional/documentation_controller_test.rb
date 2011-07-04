require 'test_helper'

class DocumentationControllerTest < ActionController::TestCase
  test "Getting documentation" do
    get :index
    roles = assigns(:roles)
    assert_equal(roles.length, 2)
    role_data = JSON.parse(roles[0])
    assert_equal(role_data["name"], "alpha")
    assert_equal(role_data["data"], "alpha data")

    role_data = JSON.parse(roles[1])
    assert_equal(role_data["name"], "charlie")
    assert_equal(role_data["data"], "charlie data")
  end
end
