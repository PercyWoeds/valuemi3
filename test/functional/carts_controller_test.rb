test "should destroy cart" do
assert_difference('Cart.count', -1) do

session[:cart_id] = @cart.id
delete :destroy, id: @cart
end

assert_redirected_to store_path
end