class Dog 
  attr_accessor :name, :breed, :id
  
  def initialize(init_args)
    # @id = init_args[:id]
    # @name = init_args[:name]
    # @breed =init_args[:breed] 
    init_args.each {|key, value| self.send(("#{key}="), value)}
    self.id ||= nil
  end
    
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dogs (id INTEGER PRIMARY KEY, 
    name TEXT, breed TEXT);
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE dogs;
    SQL
    DB[:conn].execute(sql)
  end
  
  def save
    sql = <<-SQL
      INSERT INTO dogs(name, breed)
      VALUES (?,?)
    SQL
    DB[:conn].execute(sql, self.name, self.breed)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    self
  end
  
  def self.create(init_args)
    new_dog = Dog.new(init_args)
    new_dog.save
    new_dog
  end
  
  def self.new_from_db(row)
    new_dog = {
    :id => row[0],
    :name => row[1],
    :breed => row[2]
    }
    self.new(new_dog)
  end
  
  def self.find_by_id(id)
    sql ="SELECT * FROM dogs WHERE id = ?"
     DB[:conn].execute(sql, id).map do |row|
       self.new_from_db(row)
     end.first
  end
  
  def self.find_or_create_by(name:, breed:)
      sql = <<-SQL
      SELECT * FROM dogs
      WHERE name = ? AND breed = ?
      SQL
   dog = DB[:conn].execute(sql, name, breed).first
    if dog
      new_dog = self.new_from_db(dog)
    else 
      new_dog = self.create(name: name, breed: breed)
    end
    new_dog
  end
  
  def self.find_by_name(name)
    sql = <<-SQL
    
    SQL
  end
      
end
