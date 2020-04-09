class Dog 
  attr_accessor :name, :breed
  attr_reader :id
  
  def initialize(init_args)
    @id = init_args[:id]
    @name = init_args[:name]
    @breed =init_args[:breed] 
    #or this too init_args.each {|key,value| self.send(("#{key}="),value)}
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
    new_dog = self.new(init_args)
    new_dog
  end
  
end
