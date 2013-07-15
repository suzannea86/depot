class PaymentType < ActiveRecord::Base
  attr_accessible :pay_type

  def self.pay_types
    PaymentType.all.map{|payment_type| payment_type.pay_type}
  end

end
