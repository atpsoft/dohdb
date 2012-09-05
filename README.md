DohDb
========

DohDb is a wrapper around the sequel gem -- below is an example copied from the dohmysql gem, kjmtodo update this README when have fleshed it out

``` ruby
require 'doh/db'
rows = Doh.db.select("select * from example_table")
# [[["example_table_id", 1], ["string_field", "string row1 value"], ["date_field", #<DateTime row1 value here>]], 
#  [["example_table_id", 2], ["string_field", "string row2 value"], ["date_field", #<DateTime row2 value here>]]] 
puts rows[0]['example_table_id']
# 1
row = rows[0].to_h
# {"example_table_id"=>1, "string_field"=>"string row1 value", "date_field"=>#<DateTime row1 value here>}
row.delete('example_table_id')
row['string_field'] = 'string row3 value'
insert_id = Doh.db.insert_hash(row, 'example_table')
# 3
Doh.db.select("select * from example_table where example_table_id = #{insert_id}")
# [[["example_table_id", 3], ["string_field", "string row3 value"], ["date_field", #<DateTime row1 value here>]]]

```

