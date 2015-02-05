module Checkout
  def money_format price
    format("$%.2f",price)
  end

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

  class Formatter
    attr_reader :output

    def initialize
      @output = ""
    end

    def total(total)
      output << "==============================\n"
      output << "\tTotal\t\t #{Checkout.money_format(total)}\n"
    end

    def line_item(name,qty,price)
      if (price < 0)
        output << "(Discount)\t\t-#{Checkout.money_format(-price)}\n"
      else
        output << "#{qty}x\t#{name}\t\t #{Checkout.money_format(price)}\n"
      end
    end

    def to_s
      @output
    end
  end
end

