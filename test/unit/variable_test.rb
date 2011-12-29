require 'test_helper'

class VariableTest < ActiveSupport::TestCase
  test "Store and retrieve" do
    variable = Variable.find(:name=>"foo")
    assert_equal(variable.name, "foo")
    assert_equal(variable.value, "hi")
    new_var = Variable.new()
    new_var.name= "bar"
    new_var.value = "boop"
    new_var.save()
  end
  test "Stored integer coerces to string" do
    variable = Variable.new
    new_var.name = "int value"
    new_var.value = 3
    new_var.save()
    variable = Variable.find(:name=>"int value")
    assert_equal(variable.value, "3")
  end
end
