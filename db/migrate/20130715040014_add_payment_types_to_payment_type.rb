class AddPaymentTypesToPaymentType < ActiveRecord::Migration
  def change
    PaymentType.new(:pay_type => "Check").save
    PaymentType.new(:pay_type => "Credit Card").save 
    PaymentType.new(:pay_type => "Purchase Order").save 
  end
end
