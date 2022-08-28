require_relative './../models/connections.rb'
require 'json'

def handler(event:, context:)
  # connection_idを保存する
  connection_id = event['requestContext']['connectionId']
  puts "table_name: #{ENV['TABLE_NAME']}"
  connections = Connections.new(
    Aws::DynamoDB::Resource.new,
    ENV['TABLE_NAME']
  )
  begin
    connections.add_connection(connection_id)
    { statusCode: 200, body: { message: 'OK' }.to_json }
  rescue StandardError => e
    puts e.message
    puts e.backtrace.inspect
    { statusCode: 400, body: { message: 'Opps' }.to_json }
  end
end
