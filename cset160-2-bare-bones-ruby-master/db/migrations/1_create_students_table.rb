require "sqlite3"

db = SQLite3::Database.new "./db/dev.db"

db.execute "
  create table students (
    id INTEGER PRIMARY KEY ASC,
    name VARCHAR(255),
    producer VARCHAR(255),
    platform VARCHAR(255)
  );
"

games = [
  ["Breath of the Wild", "Nintendo", "Switch"],
]

games.each do |game|
  db.execute(
    "INSERT INTO students (name, producer, platform) VALUES (?, ?, ?)", game
  )
end
