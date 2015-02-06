$:.unshift File.dirname(__FILE__)

require "lib/transaction"

# Create the rules. This could be done from an external source or DSL.
# A price rule is a block that applies a price to a list of items.
# The rule may apply a per unit price or a quantity discount.
#
# If the price rule applies to the item it will return a value.
apple_price_rule = PriceRule.new("Apple") {|qty| qty * 0.5}
apple_qty_discount = PriceRule.new("Apple") { |qty| (qty/3) * -0.2 }

orange_price_rule = PriceRule.new("Orange") { |qty| qty * 0.8}
orange_qty_discount = PriceRule.new("Orange") { |qty| (qty/2) * -0.8 }

banana_price_rule = PriceRule.new("Banana") { |qty| qty * 1.0}
banana_qty_discount = PriceRule.new("Banana") { |qty| (qty/2) * -0.5 }

# Setup the formatter and transaction objects
f = Formatter.new
t = Transaction.new(formatter: f, 
                    price_rules: [apple_price_rule, 
                      apple_qty_discount,
                      orange_price_rule,
                      orange_qty_discount,
                      banana_price_rule,
                      banana_qty_discount
                   ])

# Add items from stdin or prompt
# This could be extended to read from any source
if (ARGV.length > 0)
  ARGF.each_line do |line|
    t.add_item(line.chomp)
  end
else
  # prompt for input
  puts "Enter item names or blank line when done"
  loop do
    item = gets.chomp
    break if (item !~ /\S/)
    t.add_item(item)
  end
end

t.checkout

puts f.output

__END__
