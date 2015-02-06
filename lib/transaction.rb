require_relative "pricerule"
require_relative "formatter"
require_relative "checkout"

class Transaction

  attr_reader :price_rules, :items, :total

  # Initialize transaction with options hash.
  # - formatter: Formatter object to use to aggrigate line items. Default is a new Formatter.
  # - price_rules: Array of PriceRule objects. Defaults to empty array.
  def initialize(ops = {})
    @formatter = ops[:formatter] || Formatter.new
    @price_rules = ops[:price_rules] || []
    @total = 0
    @items = Hash.new(0)
  end

  # Add item by name to the collection of items. Increments the quantity count.
  def add_item(name)
    @items[name] += 1
  end

  # Apply price rules to each item. Add each calculated line item and total to formatter.
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

  # Apply all price rules to the item. Yield the calculated price to calling block.
  def apply_price_rules name,quantity
    @price_rules.each do |rule|
      yield rule.calculate(quantity) if rule.applicable?(name)
    end
  end
end

