class Script < ActiveRecord::Base
  validates_uniqueness_of :name

  def from_json(json)
    json_hash = JSON.parse(json)
    self.name = json_hash['name']
    self.command = json_hash['command']
    self.format = json_hash['format']
  end

  def as_json(*a)
    {
      'id' => self.id,
      'name' => self.name,
      'command' => self.command,
      'format' => self.format
    }
  end

  def validate_name(name)
    #Names must be [a-z][0-9][space]
  end

  def name=(name)
    name.downcase!
    validate_name name
    write_attribute(:name, name)
  end

  def self.new_from_json(json)
    result = self.new
    result.from_json(json)
    result
  end
end
