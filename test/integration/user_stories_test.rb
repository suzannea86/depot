require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
	fixtures :products

	test "buying a product" do

		post_via_redirect login_path, {:name => users(:one).name, :password => 'secret'}
		LineItem.delete_all
		Order.delete_all
		ruby_book = products(:ruby)

		get "/"
		assert_response :success
		assert_template "index"
	
		xml_http_request :post, '/line_items', :product_id => ruby_book.id
		assert_response :success

		cart = Cart.find(session[:cart_id])
		assert_equal 1, cart.line_items.size
		assert_equal ruby_book, cart.line_items[0].product

		get "/orders/new"
		assert_response :success
		assert_template "new"

		puts "test here"
		
		post_via_redirect "/orders",
						  :order => { :name => "Dave Thomas",
						  			  :address => "123 The Street",
						  			  :email => "dave@example.com",
						  			  :pay_type => "Check"
						  			}
		assert_response :success
		assert_template "index"

		cart = Cart.find(session[:cart_id])

		assert_equal 0, cart.line_items.size

		orders = Order.find(:all)
		assert_equal 1, orders.size
		order = orders[0] 

		assert_equal "Dave Thomas", order.name
		assert_equal "123 The Street", order.address
		assert_equal "dave@example.com", order.email
		assert_equal "Check", order.pay_type


		assert_equal 1,order.line_items.size
		line_item = order.line_items[0]
		assert_equal ruby_book, line_item.product

		mail = ActionMailer::Base.deliveries.last
		assert_equal ["dave@example.com"], mail.to
		assert_equal 'Marilyn <marilyn.aseer@gmail.com>' , mail[:from].value
		assert_equal "Pragmatic Store Order Confirmation" , mail.subject

		put_via_redirect order_path order, :order => {}

		ship_date_expected = Date.today
		order = Order.find(order.id)
		assert_equal ship_date_expected, order.ship_date


		mail = ActionMailer::Base.deliveries.last
		puts mail.subject
		assert_equal ["dave@example.com"], mail.to
		assert_equal 'Marilyn <marilyn.aseer@gmail.com>' , mail[:from].value
		assert_equal "Pragmatic Store Order Shipped" , mail.subject
	end

	test "after logout the sensitive data cannot be accessed" do

    post_via_redirect login_path, {:name => users(:one).name, :password => 'secret'}

    get "/orders"
    assert_response :success

    delete "/logout"
    assert_response :redirect
    assert_template "/"

    get "/orders"
    assert_response :redirect
    #follow_redirect!  
    #assert_equal '/login', path 
    assert_redirected_to login_url  
  end
end
