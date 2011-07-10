require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "URL handling" do
    my_role = Role.new()
    my_role.url="http://localhost:3000"
    url = my_role.url
    assert_equal(url.scheme, "http")
    assert_equal(url.port, 3000)
  end
end
