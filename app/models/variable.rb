# Stores data in JSON format, indexed by string name.
# NOTE: As per the requirements of the JSON RFC,
# 'value' is stored as a one-element array.
require 'json'

class Variable < ActiveRecord::Base
  validates_uniqueness_of :name
  def as_json(*a)
    {
      'name' => self.name,
      'value' => self.value
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
