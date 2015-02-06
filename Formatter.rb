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

