require "sqlite3"

db = SQLite3::Database.new "./db/dev.db"

db.execute "
  create table games (
    id INTEGER PRIMARY KEY ASC,
    name VARCHAR(255),
    producer VARCHAR(255),
    platform VARCHAR(255)
  );
"

games = [
  ["Chad Ostrowski", "ostrowski@stevens.edu", "ProfessorO"],
]

games.each do |game|
  db.execute(
    "INSERT INTO games (name, producer, platform) VALUES (?, ?, ?)", game
  )
end
