#kjmtodo -- update this -- leaving code in commented for now for examples
module InternalTestHelpers
  # def dbcfg
  #   { :host => 'localhost', :username => 'root', :database => 'test' }
  # end

  def table
    @table ||= self.class.to_s.gsub(/:/, '_').downcase
  end

  def drop_statement
    "DROP TABLE IF EXISTS #{table}"
  end

  def drop_table
    get_sqlite_dbh.query(drop_statement)
  end

  def get_sqlite_dbh
    require 'doh/db/sqlitehandle'
    return @handle if @handle
    @handle = DohDb::SqliteHandle.new()
  end

  def init_global_connector
    require 'doh/db/connector_instance'
    require 'doh/db/sqlite_connector'
    DohDb.set_connector_instance(DohDb::SqliteConnector.new())
  end
end

class DohTest::TestGroup
  include InternalTestHelpers
end
