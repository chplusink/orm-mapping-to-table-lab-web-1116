class Student
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(id=nil,name,grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE students (id INTEGER PRIMARY KEY, name TEXT, grade INTEGER)
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
    SQL
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?,?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)

    sql = <<-SQL
      SELECT id FROM students
      ORDER BY id DESC
      LIMIT 1
    SQL

    id_result = DB[:conn].execute(sql).first
    @id = id_result[0]
    self
  end

  def self.create(attributes={})
    new_student = Student.new(nil,nil,nil)
    attributes.each do |key,value|
      new_student.send("#{key}=", value)
    end
    new_student.save
  end

end
