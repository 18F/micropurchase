def expect_page_to_have_selected_selectize_option(field, text)
  within(".#{field}") do
    expect(page.first(".selectize-input div").text).to eq text
  end
end

def select_selectize_option(field, text)
  find(".#{field} .selectize-input input").native.send_keys(text) # fill the input text
  find(:xpath, "//div[@data-selectable and contains(., '#{text}')]").click # wait for the input and then click on it
end
