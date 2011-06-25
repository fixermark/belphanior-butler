require 'json'
require 'test_helper'

class ServantTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "servants must have unique names" do
    servant1 = Servant.new
    servant1.name = "test"
    assert(servant1.save)
    servant2 = Servant.new
    servant2.name = "test"
    assert(!servant2.save())
  end

  test "json serialization" do
    servant = Servant.new
    servant.name = 'Foo'
    servant.url = 'http://127.0.0.1:80'
    servant.protocol = "<some protocol string>"
    json_out = servant.to_json
    servant_hash = JSON.parse(json_out)
    assert_equal(servant_hash['name'], 'Foo')
    assert_equal(servant_hash['url'], 'http://127.0.0.1:80')
    assert_equal(servant_hash['protocol'], "<some protocol string>")
    assert_equal(servant_hash['status'], "loading_roles")

    servant2 = Servant.new
    servant2.name = 'Foo'
    servant2.url = 'http://127.0.0.1:80'
    json_out = servant2.to_json
    servant_hash = JSON.parse(json_out)
    assert_equal(servant_hash['name'], 'Foo')
    assert_equal(servant_hash['url'], 'http://127.0.0.1:80')
    assert_equal(servant_hash['status'], "loading_protocol")
  end

  test "json deserialization" do
    json = "{\"name\":\"foo\", \"url\":\"http://127.0.0.1\", " +
      "\"protocol\":\"<A protocol>\"}"

    servant = Servant.new_from_json(json)
    assert_equal(servant.name, "foo")
    assert_equal(servant.url, "http://127.0.0.1")
    assert_equal(servant.protocol, "<A protocol>")

    # partial deserialization
    json = "{\"name\":\"foo\"}"
    servant2 = Servant.new_from_json(json)
    assert_equal(servant.name, "foo")
  end

  test "complete role urls" do
    json = <<-eof
    {
      "name" : "foo",
      "url" : "http://127.0.0.1",
      "protocol" : "{\\\"roles\\\" : [{\\\"role_url\\\" : \\\"http://myhost.com:3000/relative/path\\\",\\\"handlers\\\" : []}]}"
    }       
    eof
    servant = Servant.new_from_json(json)
    urls = servant.role_urls
    assert_equal("myhost.com", urls[0].host)
    assert_equal(3000, urls[0].port)
    assert_equal("http", urls[0].scheme)
    assert_equal("/relative/path", urls[0].path)
  end

  test "incomplete role urls" do
    json = <<-eof
    {
      "name" : "foo",
      "url" : "http://127.0.0.1",
      "protocol" : "{\\\"roles\\\" : [{\\\"role_url\\\" : \\\"/relative/path\\\",\\\"handlers\\\" : []}]}"
    }       
    eof
    servant = Servant.new_from_json(json)
    urls = servant.role_urls
    assert_equal("127.0.0.1", urls[0].host)
    assert_equal(80, urls[0].port)
    assert_equal("http", urls[0].scheme)
    assert_equal("/relative/path", urls[0].path)
  end
end
