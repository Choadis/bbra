require "cuba"
require "cuba/safe"
require "cuba/render"
require "erb"
require "sqlite3"

Cuba.use Rack::Session::Cookie, :secret => ENV["SESSION_SECRET"] || "__a_very_long_string__"

Cuba.plugin Cuba::Safe
Cuba.plugin Cuba::Render

db = SQLite3::Database.new "./db/dev.db"

students = db.execute("SELECT * FROM students").map do |name, email, discord|
  { :name => name, :email => email, :discord => discord }
end

Cuba.define do
  on "about" do
    res.write view("about")
  end

  on root do
    res.write view("index", students: students)
  end

  def not_found
    super
    res.write view("404")
  end
end
