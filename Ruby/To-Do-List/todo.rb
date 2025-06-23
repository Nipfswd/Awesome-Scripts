require 'sqlite3'

DB_FILE = "todo.db"

# Initialize database if it doesn't exist
def init_db
  db = SQLite3::Database.new(DB_FILE)
  db.execute <<-SQL
    CREATE TABLE IF NOT EXISTS tasks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      description TEXT NOT NULL,
      done BOOLEAN DEFAULT 0
    );
  SQL
  db.close
end

def add_task(desc)
  db = SQLite3::Database.new(DB_FILE)
  db.execute("INSERT INTO tasks (description) VALUES (?)", desc)
  db.close
  puts "Task added: #{desc}"
end

def list_tasks
  db = SQLite3::Database.new(DB_FILE)
  rows = db.execute("SELECT id, description, done FROM tasks ORDER BY id")
  rows.each do |row|
    status = row[2] == 1 ? "[X]" : "[ ]"
    puts "#{row[0]} #{status} #{row[1]}"
  end
  db.close
end

def mark_done(id)
  db = SQLite3::Database.new(DB_FILE)
  db.execute("UPDATE tasks SET done = 1 WHERE id = ?", id)
  db.close
  puts "Task #{id} marked as done."
end

def delete_task(id)
  db = SQLite3::Database.new(DB_FILE)
  db.execute("DELETE FROM tasks WHERE id = ?", id)
  db.close
  puts "Task #{id} deleted."
end

# CLI interface
init_db

command = ARGV.shift

case command
when "add"
  desc = ARGV.join(" ")
  add_task(desc)
when "list"
  list_tasks
when "done"
  id = ARGV.shift.to_i
  mark_done(id)
when "delete"
  id = ARGV.shift.to_i
  delete_task(id)
else
  puts <<-USAGE
Usage:
  ruby todo.rb add "Task description"
  ruby todo.rb list
  ruby todo.rb done TASK_ID
  ruby todo.rb delete TASK_ID
  USAGE
end
