require 'rack'

app = Proc.new do |env|
  [
    '200',
    {'Content-Type' => 'text/html'},
    ["
      <h1>Hello world!</h1>
      <p>The time is #{Time.now}</p>
    "]
  ]
end

Rack::Handler.default.run app, :Port => 5678
