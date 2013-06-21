require 'nokogiri'
require 'sqlite3'
require 'open-uri'
require 'debugger'

class Student

  attr_accessor :id, :name
  DB = SQLite3::Database.new "school.db"

  def self.create_table
    DB.execute "CREATE TABLE IF NOT EXISTS students(
      Id INTEGER PRIMARY KEY, 
      name TEXT)"
  end

  def self.drop
    DB.execute "DROP TABLE students"
    
  end

# we may consider adding a name parameter, right now this only checks for duplicate ID's
  def exist?  
   !DB.execute("SELECT name FROM students WHERE Id = ? ", @id).empty?
  end


  drop if DB

  create_table

  def self.table_exists?(table_name)
    if DB.execute("SELECT name FROM sqlite_master WHERE type='table' AND name=?", table_name)[0]
      DB.execute("SELECT name FROM sqlite_master WHERE type='table' AND name=?", table_name)[0][0] == table_name
    else
      false
    end
  end

  def save
     # if students exists
     #   update table
     # else 
     #   put in the db and query the id
    if exist?
      DB.execute("UPDATE students SET name=:name WHERE id = :id", {:name => @name, :id => @id})
    else
      DB.execute("INSERT INTO students (name) VALUES (:name)", {:name => @name})
      @id = DB.execute("SELECT id FROM students WHERE name = ?", @name).first.first 
    # if does not exist
    # then just update
    end
  end

  def initialize
  end

  def self.find_by_name(name)
    student = Student.new
    student.name = DB.execute("SELECT name FROM students WHERE name = ?", name)[0][0]
    student.id = DB.execute("SELECT id FROM students WHERE name = ?", name)[0][0]
    student
  end

  def self.find(parameter)
    student = Student.new
    student.name = DB.execute("SELECT name FROM students WHERE id = ?", parameter)[0][0]
    student.id = parameter
    # student = Student.new
    #student.id = DB.execute("SELECT id FROM students WHERE id = ?", parameter)[0][0]
    # student.name = DB.execute("SELECT name FROM students WHERE id = ?", parameter)[0][0]
    student
  end

  def self.put_all
    p all
  end

 def self.all
    all_student = []
    array =DB.execute("SELECT * FROM students")
    array.each do |row|
      student = Student.new
        student.name = row[1]
        student.id = row[0]
        all_student << student
    end
    all_student
  end

  def self.where(hash)
    # student = Student.new
    student = [] 
    student << find_by_name(hash[:name])
    # student.id = DB.execute("SELECT id FROM students WHERE name = ?", @name)[0][0]
    student
  end
end

