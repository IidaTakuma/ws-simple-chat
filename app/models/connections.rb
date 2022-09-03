require 'aws-sdk-dynamodb'

class Connections

  attr_reader :table

  def initialize(table_name)
    load_table(table_name)
  end

  def load_table(table_name)
    @table = Aws::DynamoDB::Table.new(table_name).load
    nil

  rescue Aws::DynamoDB::Errors::ResourceNotFoundException
    puts "Table #{table_name} doesn't exist. Please create table before execute this Programm."
    raise
  rescue Aws::Errors::ServiceError => e
    puts("Couldn't check for existence of #{table_name}. Here's why:")
    puts("\t#{e.code}: #{e.message}")
    raise
  end

  def add_connection(connection_id)
    @table.put_item(
      item: { 'connectionId' => connection_id }
    )
  rescue Aws::Errors::ServiceError => e
    puts("Couldn't add connectionId: #{connection_id} to table #{@table.name}. Here's why:")
    puts("\t#{e.code}: #{e.message}")
    raise
  end

  def delete_connection(connection_id)
    @table.delete_item(
      key: { 'connectionId' => connection_id }
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
    }
    done = false
    start_key = nil
    until done
      scan_hash[:exclusive_start_key] = start_key unless start_key.nil?
      response = @table.scan(scan_hash)
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
