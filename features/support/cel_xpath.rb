def cel_xpath(table_id: nil, row: 1, column: 1)
  table_id_str = table_id ? "[@id=\"#{table_id}\"]" : ''
  "//table#{table_id_str}/tbody/tr[#{row}]/td[#{column}]"
end

def th_xpath(table_id: nil, row: 1, column: 1)
  table_id_str = table_id ? "[@id=\"#{table_id}\"]" : ''
  "//table#{table_id_str}/thead/tr[#{row}]/th[#{column}]"
end
