require 'rethinkdb'

module Wisethinker
  module StorageAccessor
    class Rethink

      attr_reader :rql

      def initialize database: 'wisethinker', table: 'documents', host: 'localhost', port: 28015
        @rql = RethinkDB::RQL.new
        @host = host
        @port = port
        @database = database
        @table = table

        create_database database
        create_table table
      end

      def find_by_type_and_url_name type, url_name
        connection do |conn|
          table.filter(type: type, url_name: url_name).run(conn).first
        end
      end

      def find_all_by_type type, direction: :descending
        connection do |conn|
          type = Array(type)
          table.filter{|record|
            record["type"].match("(#{type.join("|")})")
          }.run(conn).to_a
        end
      end

      def upsert query, json
        connection do |conn|
          #the upsert flag is mentioned but doesn't seem to work
          #table.insert(json, {upsert: true}).run(conn)

          #For now I will simply delete the recored if it exists and then insert
          table.filter(query).delete.run(conn)
          table.insert(json).run(conn)
        end
      end

      def delete type, url
        connection do |conn|
          table.filter({type: type, url_name: url}).delete.run(conn)
        end
      end

      def table
        @rql.table(@table)
      end

      def drop_database
        connection do |conn|
          @rql.db_drop(@database).run(conn)
        end
      end

      def create_database name
        ignore_exception_already_exists do
          connection do |conn|
            @rql.db_create(name).run(conn)
          end
        end
      end

      def create_table name
        ignore_exception_already_exists do
          connection do |conn|
            @rql.table_create(name).run(conn)
          end
        end
      end

      def ignore_exception_already_exists &block
        begin
          block.call
        rescue RethinkDB::RqlRuntimeError => ex
          raise ex unless ex.message =~ /already exists/
        end
      end

      def connection &block
        #begin
          conn = @rql.connect host: @host, port: @port, db: @database

          result = block.call(conn)
          conn.close
          result
        #rescue Exception => err
        #   puts "EXCEPTION!!!!"
        #end
      end

    end
  end
end
