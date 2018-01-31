require "cuba"
require "cuba/safe"
require "cuba/render"
require "erb"
require "sqlite3"

Cuba.use Rack::Session::Cookie, :secret => ENV["SESSION_SECRET"] || "__a_very_long_string__"

Cuba.plugin Cuba::Safe
Cuba.plugin Cuba::Render

db = SQLite3::Database.new "./db/dev.db"

Cuba.define do
  on root do
    game_array = db.execute("SELECT * FROM students")
    games = game_array.map do |id, name, producer, platform|
      { :id => id, :name => name, :producer => producer, :platform => platform }
    end
    res.write view("index", games: games)
  end
  on "new" do
    res.write view("new")
  end

  on get, "/edit/:id" do |id|
    game = game_array(:id)
    res.write view("edit", game: game)
  end

  on "edit/:id" do |id|
    res.write view("edit")
  end


  on post do
    on "create" do
      name = req.params["name"]
      producer = req.params["producer"]
      platform = req.params["platform"]
      db.execute(
        "INSERT INTO students (name, producer, platform) VALUES (?, ?, ?)",
        name, producer, platform
      )
      res.redirect "/"
    end

    on post do
      on "edit" do
        name = req.params["name"]
        producer = req.params["producer"]
        platform = req.params["platform"]
        db.execute(
          "DELETE FROM students WHERE id=#{id}"
        )
        db.execute(
          "INSERT INTO students (name, producer, platform) VALUES (?, ?, ?) WHERE id=#{id}",
          name, producer, platform,
        )
        res.redirect "/"
      end
end
    on "delete/:id" do |id|
      db.execute(
        "DELETE FROM students WHERE id=#{id}"
      )
      res.redirect "/"
    end
  end

  def not_found
    res.status = "404"
    res.headers["Content-Type"] = "text/html"

    res.write view("404")
  end
end
