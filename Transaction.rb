require_relative "PriceRule"
require_relative "Formatter"
require_relative "Checkout"

class Transaction

  attr_reader :price_rules, :items, :total

  def initialize(ops = {})
    @formatter = ops[:formatter] || Formatter.new
    @price_rules = ops[:price_rules] || []
    @total = 0
    @items = Hash.new(0)
  end

  def add_item(name)
    @items[name] += 1
  end

  def checkout
    @items.each do |name,qty|
      item_total = 0

      apply_price_rules(name,qty) do |price| 
        item_total += price
        @formatter.line_item(name,qty,price)
      end

      @total += item_total
    end

    @formatter.total(@total)
  end

  private 

  def apply_price_rules name,quantity
    @price_rules.each do |rule|
      yield rule.calculate(quantity) if rule.applicable?(name)
    end
  end
end

