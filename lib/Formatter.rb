class Formatter
  attr_reader :output

  # Initialize with empty output
  def initialize
    @output = ""
  end

  # Format total line
  def total(total)
    output << "==============================\n"
    output << "\tTotal\t\t #{Checkout.money_format(total)}\n"
  end

  # Format positive and negative (discount) line items
  def line_item(name,qty,price)
    if (price < 0)
      output << "(Discount)\t\t-#{Checkout.money_format(-price)}\n"
    else
      output << "#{qty}x\t#{name}\t\t #{Checkout.money_format(price)}\n"
    end
  end

  # Override to_s to return built output
  def to_s
    @output
  end
end

