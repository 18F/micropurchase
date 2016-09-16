def needs_attention_table_xpath(section)
  table_title = I18n.t("needs_attention.index.#{section}")
  "//h2[text()='#{table_title}']/following-sibling::table[1]"
end
