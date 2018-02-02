require "cuba"
require "cuba/safe"
require "cuba/render"
require "erb"
require "sqlite3"
require "ostruct"
require_relative "./models/student"

Cuba.use Rack::Session::Cookie, :secret => ENV["SESSION_SECRET"] || "__a_very_long_string__"

Cuba.plugin Cuba::Safe
Cuba.plugin Cuba::Render

db = SQLite3::Database.new "./db/dev.db"

Cuba.define do
  on root do
    game = Game.all
    res.write view("index", games: Game.all)
  end

  on get, "new" do
    res.write view("new")
  end

  on post, "create" do
      name = req.params["name"]
      producer = req.params["producer"]
      platform = req.params["platform"]
      db.execute(
        "INSERT INTO students (name, producer, platform) VALUES (?, ?, ?)",
        name, producer, platform
      )
      res.redirect "/"
    end

  on get, "edit/:id" do |id|
    games = db.execute(
      'SELECT * FROM games WHERE id = ?', id
    ).first
    game = OpenStruct.new(id: games[0], name: games[1], producer: games[2], platform: games[3]
    )
    res.write view("edit", game: game.all)
  end

  on post,'update/:id' do
    db.execute(
      "UPDATE students SET (name, producer, platform)=(?, ?, ?) WHERE id =?",
    req.params["name"],
    req.params["producer"],
    req.params["platform"],
    id,
  )
    res.redirect "/"
  end

  on post, "delete/:id" do |id|
      db.execute(
        "DELETE FROM students WHERE id=#{id}"
      )
      res.redirect "/"
    end

  def not_found
    res.status = "404"
    res.headers["Content-Type"] = "text/html"

    res.write view("404")
  end
end
