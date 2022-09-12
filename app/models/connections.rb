require 'aws-sdk-dynamodb'

class Connections

  def initialize(table_name)
    @table_name = table_name
    load_client
  end

  def load_client
    client_options = if ENV['IS_OFFLINE']
      {
        region: 'ap-northeast-1',
        endpoint: 'http://localhost:8000',
        credentials: Aws::Credentials.new(
          'DEFAULT_ACCESS_KEY',
          'DEFAULT_SECRET'
        )
      }
    else
      {}
    end

    @client = Aws::DynamoDB::Client.new(client_options)

  rescue Aws::DynamoDB::Errors::ResourceNotFoundException
    puts "Table #{@table_name} doesn't exist."
    raise
  rescue Aws::Errors::ServiceError => e
    puts("error_message: #{e.message}")
    raise
  end

  def add_connection(connection_id)
    @client.put_item(
      item: { connectionId: connection_id },
      table_name: @table_name
    )
  rescue Aws::Errors::ServiceError => e
    puts("\t#{e.code}: #{e.message}")
    raise
  end

  def delete_connection(connection_id)
    @client.delete_item(
      key: { 'connectionId' => connection_id },
      table_name: @table_name
    )
  rescue Aws::Errors::ServiceError => e
    puts("Couldn't delete connectionId #{connection_id}. Here's why:")
    puts("\t#{e.code}: #{e.message}")
    raise
  end

  def scan_connections
    connections = []

    scan_hash = {
      projection_expression: '#connectionId',
      expression_attribute_names: {'#connectionId' => 'connectionId'},
      table_name: @table_name
    }
    done = false
    start_key = nil
    until done
      scan_hash[:exclusive_start_key] = start_key unless start_key.nil?
      response = @client.scan(scan_hash)
      connections.concat(response.items) unless response.items.nil?
      start_key = response.last_evaluated_key
      done = start_key.nil?
    end
  rescue Aws::Errors::ServiceError => e
    puts("Couldn't scan connection ids. Here's why:")
    puts("\t#{e.code}: #{e.message}")
    raise
  else
    connections
  end
end
