require 'test_helper'

class VariableTest < ActiveSupport::TestCase
  test "Store and retrieve" do
    variable = Variable.find_by_name("foo")
    assert_equal(variable.name, "foo")
    assert_equal(variable.value, "hi")
    new_var = Variable.new
    new_var.name= "bar"
    new_var.value = "boop"
    new_var.save()
  end
  test "JSON type preservation" do
    string_value = "hi"
    int_value = 3
    array_value = [1, "bar", 3]
    object_value = {'one' => 1, 'two' => 2, 'three' => 3}

    new_var = Variable.new
    new_var.name = "string var"
    new_var.value = string_value
    new_var.save()

    new_var = Variable.new
    new_var.name = "int var"
    new_var.value = int_value
    new_var.save()

    new_var = Variable.new
    new_var.name = "array var"
    new_var.value = array_value
    new_var.save()

    new_var = Variable.new
    new_var.name = "object var"
    new_var.value = object_value
    new_var.save()

    var = Variable.find_by_name("string var")
    assert_equal(var.value, string_value)

    var = Variable.find_by_name("int var")
    assert_equal(var.value, int_value)

    var = Variable.find_by_name("array var")
    assert_equal(var.value, array_value)

    var = Variable.find_by_name("object var")
    assert_equal(var.value, object_value)
  end
end
