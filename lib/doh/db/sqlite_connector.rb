require 'sequel'
module DohDb
class SqliteConnector
  #nil filename means a memory db
  def initialize(filename = nil)
    @handle = Sequel.sqlite(filename)
  end
  def request_handle(database = nil)
    return @handle
  end
end
end
