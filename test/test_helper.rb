ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class Test::Unit::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def raw_post(action, params, body)
    @request.env['RAW_POST_DATA'] = body
    response = post(action, params)
    @request.env.delete('RAW_POST_DATA')
    response
  end

  def assert_ok_status
    assert_equal(200, @response.response_code)
    response_json = JSON.parse(@response.body)
    assert_equal("OK", response_json["status"])
  end

  # Validates that two JSON-style objects are equivalent
  # Equivalence is defined as follows:
  #   Array type: each element equivalent
  #   Dict type: For each key |k| in reference, key in value
  #    exists and value for the key is equivalent. 
  #    NOTE: This means that the input can contain 
  #    additional data, and this is acceptable.
  #   All others: Simple ruby equivalence.
  def assert_equivalent_json_objects(reference, tested)
    assert_equal(reference.class(), tested.class())
    if reference.class() == [].class()
      assert_equal(reference.length, tested.length)
      for i in 0..reference.length
        assert_equivalent_json_objects(
          reference[i], tested[i])
      end
    elsif reference.class() == {}.class()
      reference.each do |key, value|
        assert_equal(true, tested.has_key?(key))
        assert_equivalent_json_objects(value, tested[key])
      end
    else
    # String or number (or other type): value compare
      assert_equal(reference, tested)  
    end
  end

  def assert_ok_with_data(data)
    assert_equal(200, @response.response_code)
    response_json = JSON.parse(@response.body)
    assert_equivalent_json_objects(data, response_json)
  end

  def assert_status(status_value)
    assert_equal(status_value, @response.response_code)
  end
end
