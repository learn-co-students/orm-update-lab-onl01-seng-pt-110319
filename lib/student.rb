require_relative "../config/environment.rb"
require 'pry'
class Student

  attr_accessor :name, :grade
  attr_reader :id 

  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    DB[:conn].execute("CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade TEXT);")
  end

  def self.drop_table
   DB[:conn].execute("DROP TABLE IF EXISTS students;")
  end

  def save
    if id
      update
    else
      DB[:conn].execute("INSERT INTO students (name, grade) VALUES (?, ?);", name, grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students;")[0][0]
    end
  end

  def update
    DB[:conn].execute("UPDATE students SET name = ?, grade = ? WHERE id = ?", name, grade, id)
  end

  def self.create(name, grade)
    new_student = new(name, grade)
    new_student.save
    new_student
  end

  def self.new_from_db(row)
    id = row[0]
    name = row[1]
    grade = row[2]
    new(id, name, grade)
  end

  def self.find_by_name(name)
    find_by_name = DB[:conn].execute("SELECT * FROM students WHERE name = ?;", name)[0]
    new(find_by_name[0], find_by_name[1], find_by_name[2])
  end
end
