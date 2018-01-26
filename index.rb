require "cuba"
require "cuba/render"
require "erb"

Cuba.plugin Cuba::Render
Cuba.define do
  on "about" do
    res.write view("about")
  end
  on root do
    res.write view("index")
  end
  def not_found
    super
    res.write view("404")
  end
end
