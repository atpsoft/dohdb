require_relative 'helpers'
require 'doh/db/sqlitehandle'

module DohDb

class Test_SqliteHandle < DohTest::TestGroup
  def test_stuff
    dbh = get_sqlite_dbh
    dbh.query("create table #{table} (id primary_key, value int, created_on date, created_at datetime, money float)")
    assert_equal(1, dbh.insert("INSERT INTO #{table} (id, created_on, created_at, money) VALUES (null, DATE(), '2007-01-01 10:30:05', 10.5)"))
    assert_equal(2, dbh.insert("INSERT INTO #{table} (id, created_on, created_at) VALUES (null, 0, 0)"))
    assert_equal(3, dbh.insert("INSERT INTO #{table} (id) VALUES (null)"))
    onerow = dbh.select_row("SELECT * FROM #{table}")
    assert_equal(1, onerow['id'])
    rows = dbh.select("SELECT * FROM #{table}")
    rows.each {|row| assert(row['id'] != 0)}
  end

  def test_select_transpose_2fields
    dbh = get_sqlite_dbh
    dbh.query("CREATE TEMPORARY TABLE #{table} (field CHAR(30) NOT NULL, value CHAR(30) NOT NULL)")
    dbh.query("INSERT INTO #{table} SET field = 'some_name', value = 'some_value'")
    dbh.query("INSERT INTO #{table} SET field = 'other_name', value = 'matching_other_value'")
    dbh.query("INSERT INTO #{table} SET field = 'yet_another_name', value = 'strange_value'")
    hash = dbh.select_transpose("SELECT field, value FROM #{table}")
    assert_equal('some_value', hash['some_name'])
    assert_equal('matching_other_value', hash['other_name'])
    assert_equal('strange_value', hash['yet_another_name'])
  end

  def test_select_transpose_3fields
    dbh = get_sqlite_dbh
    dbh.query("CREATE TEMPORARY TABLE #{table} (field CHAR(30), some_value CHAR(30), other_value CHAR(30))")
    dbh.query("INSERT INTO #{table} SET field = 'some_name', some_value = 'some_value', other_value = 'blah'")
    dbh.query("INSERT INTO #{table} SET field = 'other_name', some_value = 'matching_other_value', other_value = 'blee'")
    dbh.query("INSERT INTO #{table} SET field = 'yet_another_name', some_value = 'strange_value', other_value = 'bloo'")
    hash = dbh.select_transpose("SELECT field, some_value, other_value FROM #{table}")
    assert_equal(hash['some_name'], {'some_value' => 'some_value', 'other_value' => 'blah'})
    assert_equal(hash['other_name'], {'some_value' => 'matching_other_value', 'other_value' => 'blee'})
    assert_equal(hash['yet_another_name'], {'some_value' => 'strange_value', 'other_value' => 'bloo'})
  end

  def test_select_values
    dbh = get_sqlite_dbh
    dbh.query("CREATE TEMPORARY TABLE #{table} (field CHAR(30), some_value CHAR(30))")
    dbh.query("INSERT INTO #{table} SET field = 'some_name', some_value = 'some_value'")
    assert_equal([['some_name', 'some_value']], dbh.select_values("SELECT field, some_value FROM #{table}"))
    assert_equal([['some_name']], dbh.select_values("SELECT field FROM #{table}"))
  end

  def test_insert_hash
    dbh = get_sqlite_dbh
    dbh.query("CREATE TEMPORARY TABLE #{table} (value INT KEY)")
    hash1 = {'value' => 1}
    assert_equal(0, dbh.insert_hash(hash1, table))
    assert_raises(Mysql2::Error) { dbh.insert_hash(hash1, table) }
    assert_equal(0, dbh.insert_ignore_hash(hash1, table))
  end
end

end
