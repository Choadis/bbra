DB = SQLite3::Database.new "./db/dev.db"

class Game
  attr_accessor :id, :name, :producer, :platform
  def initialize(id, name, producer, platform)
    @id = id
    @name = name
    @producer = producer
    @platform = platform
    @db = SQLite3::Database.new "./db/dev.db"
end

def self.all
  game_array = DB.execute("SELECT * FROM students")
  game_array.map do |id, name, producer, platform|
    Game.new(id, name, producer, platform)
end
end
end
