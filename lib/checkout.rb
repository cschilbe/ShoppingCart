class Checkout
  # Helper method for consistant formatting for money
  def self.money_format price
    format("$%.2f",price)
  end
end

