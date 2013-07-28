require 'test_helper'

class CartTest < ActiveSupport::TestCase
  test "add_unique_products" do
    cart = Cart.new
    cart.save
    product = products(:one)
    assert_difference ("cart.line_items.count") do
      line_item = cart.add_product(product.id)
      line_item.save
    end

    product2 = products(:two)
    assert_difference ("cart.line_items.count") do
      line_item = cart.add_product(product2.id)
      line_item.save
    end  
  end

  test "add_duplicate_products" do
    cart = Cart.new
    cart.save
    product = products(:one)

    line_item = cart.add_product(product.id)
    line_item.save
    
    assert_no_difference("cart.line_items.count") do
      line_item = cart.add_product(product.id)
      line_item.save
    end

    assert_equal 2, cart.line_items.first.quantity
  end 
end

