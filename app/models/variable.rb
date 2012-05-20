# Stores data in JSON format, indexed by string name.
# NOTE: As per the requirements of the JSON RFC,
# 'value' is stored as a one-element array.
require 'json'

class Variable < ActiveRecord::Base
  validates_uniqueness_of :name
  def from_json(json)
    puts "Hello, world!"
    prototype = JSON.parse(json)
    self.name = prototype['name']
    self.value = JSON.parse(prototype['value'])[0]
    self.id = prototype['id']
  end

  def as_json(*a)
    {
      'name' => self.name,
      'value' => read_attribute(:value),
      'id' => self.id
    }
  end
  def value
    JSON.parse(read_attribute(:value))[0]
  end
  def value=(new_value)
    write_attribute(:value, JSON.generate([new_value]))
  end
  def self.new_from_json(json)
    result = self.new
    result.from_json(json)
    result
  end
end
