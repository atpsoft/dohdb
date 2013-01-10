require 'doh/log/stub'

module DohDb
class SqliteHandle
  attr_reader :config, :sqliteh
  def initialize(config = {})
    @config = config
    log_config = @config.dup
    log_config.delete(:password)
    dohlog.info("creating connection with config: #{log_config}")
    #right now we just do a filename or memory (nil filename)
    @sqliteh = Sequel.sqlite(@config[:filename])
  end
  def query(statement)
    result = generic_query(statement)
    puts "\nquery result for #{statement.inspect}: #{result.inspect}\n" #kjmtodo remove this
  end
  def insert(statement)
    retval = @sqliteh.execute_insert(statement)
    dohlog.info("insert_id was #{retval}")
    retval
  rescue Exception => excpt
    dohlog.error("caught exception during insert: #{statement}", excpt)
    raise
  end
  def select_row(statement)
    @sqliteh.execute(statement) do |rows|
      puts "rows.count = #{rows.count}, rows = #{rows.columns.inspect}"
      return rows.first
    end
  rescue Exception => excpt
    dohlog.error("caught exception during insert: #{statement}", excpt)
    raise
  end
private
  def generic_query(statement)
    dohlog.info(statement)
    @sqliteh.run(statement)
  rescue Exception => excpt
    dohlog.error("caught exception during query: #{statement}", excpt)
    raise
  end
end
end
