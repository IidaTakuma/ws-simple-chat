require_relative './../models/connections.rb'
require 'json'

def handler(event:, context:)
  connection_id = event['requestContext']['connectionId']
  connections = Connections.new(ENV['CONNECTIONS_TABLE'])

  begin
    connections.add_connection(connection_id)
    { statusCode: 200, body: { message: 'Joined room.' }.to_json }
  rescue StandardError => e
    puts e.message
    puts e.backtrace.inspect
    { statusCode: 400, body: { message: 'Opps' }.to_json }
  end
end
