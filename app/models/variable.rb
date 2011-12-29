class Variable < ActiveRecord::Base
  validates_uniqueness_of :name
  def as_json(*a)
    {
      'name' => self.name,
      'value' => self.value
    }
  end
  def self.new_from_json(json)
    result = self.new
    result.from_json(json)
    result
  end
end
