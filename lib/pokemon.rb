require "pry"
class Pokemon
  
  attr_accessor :id, :name, :type, :db
  
  def initialize(attributes)
    attributes.each { |attribute, value| self.send("#{attribute}=", value) }
  end
  
  def self.save(name, type, db)
    pokemon = self.new(name: name, type: type, db: db)
    
    sql = <<-SQL
      INSERT INTO pokemon (name, type)
      VALUES (?, ?);
    SQL
    
    db.execute(sql, name, type)
    pokemon.id = db.execute("SELECT last_insert_rowid() FROM pokemon;")[0][0]
  end
  
  def self.find(id, db)
    sql = <<-SQL
      SELECT pokemon.name, pokemon.type FROM pokemon
      WHERE pokemon.id = ?
      LIMIT 1
    SQL
    
    db.execute(sql, id).map do |row|
      self.new(row)
    end.first
  end
  
end
