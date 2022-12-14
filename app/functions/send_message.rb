require_relative './../models/connections.rb'
require 'aws-sdk-apigatewaymanagementapi'
require 'json'

def handler(event:, context:)
  connections = Connections.new(ENV['CONNECTIONS_TABLE'])
  message = JSON.parse(event['body'])['data']
  receivers = connections.scan_connections

  endpoint = "https://#{event['requestContext']['domainName']}/#{event['requestContext']['stage']}"
  apigwManagementApiClient = Aws::ApiGatewayManagementApi::Client.new(endpoint: endpoint)

  receivers.each do |receiver|
    begin
      apigwManagementApiClient.post_to_connection({
        data: message,
        connection_id: receiver['connectionId']
      })
    rescue StandardError => e
      puts e.message
      puts e.backtrace.inspect
    end
  end
  { statusCode: 200, body: { message: 'Data sent.' }.to_json }
end
