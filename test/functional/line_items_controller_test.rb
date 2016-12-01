test  "should create line_item" do
assert_difference('LineItem.count') do

post :create, product_id: products(:ruby).id
end

assert_redirected_to store_path(assi gns(:line_item).cart)

end