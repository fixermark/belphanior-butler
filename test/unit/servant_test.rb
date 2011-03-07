require 'test_helper'

class ServantTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "servants must have unique names" do
    servant1 = Servant.new
    servant1.name = "test"
    assert(servant1.save)
    servant2 = Servant.new
    servant2.name = "test"
    assert_raise(ActiveRecord::StatementInvalid,
                 "Second save did not fail due to duplicate name.") {
      servant2.save
    }
  end
end
