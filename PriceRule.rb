class PriceRule
  def initialize(name,&calculate)
    @name = name
    @calculate = calculate
  end

  def applicable? name
    return @name === name
  end

  def calculate qty
    return @calculate.call(qty)
  end
end

