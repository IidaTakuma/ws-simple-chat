require_relative './../models/connections.rb'
require 'json'

def handler(event:, context:)
  connection_id = event['requestContext']['connectionId']
  connections = Connections.new(ENV['TABLE_NAME'])

  begin
    connections.delete_connection(connection_id)
    { statusCode: 200, body: { message: 'Left room.' }.to_json }
  rescue StandardError => e
    puts e.message
    puts e.backtrace.inspect
    { statusCode: 400, body: { message: 'Opps' }.to_json }
  end
end
