class AdminController < ApplicationController
  # def login
  #   if User.count.zero?
  #     redirect_to(:controller => 'users', :action => 'new')
  #   end  
  # end  
  
  def index
    @total_orders = Order.count
  end
end
