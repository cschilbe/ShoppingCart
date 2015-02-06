
class PriceRule
  # Initialize PriceRule instance with name and calculate block.
  def initialize(name,&calculate)
    @name = name
    @calculate = calculate
  end

  # Check if this price rule is applicable to the item being evaluated.
  def applicable? name
    return @name === name
  end

  # Calculate the price of the item based on quantity.
  # Defer calculation to price rule calculate block.
  def calculate qty
    return @calculate.call(qty)
  end
end

