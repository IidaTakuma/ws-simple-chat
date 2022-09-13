require_relative './../models/connections.rb'
require 'json'

def handler(event:, context:)
  begin
    connections = Connections.new(ENV['CONNECTIONS_TABLE']) # dynamodb connection test

    connections.add_connection('test_123')
    connections.scan_connections
    connections.delete_connection('test_123')

    { statusCode: 200, body: { message: 'ok' }.to_json }
  rescue StandardError => e
    puts e.message
    puts e.backtrace.inspect
    { statusCode: 400, body: { message: 'Bad request' }.to_json }
  end
end
