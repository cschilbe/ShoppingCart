require "test/unit"
require_relative "Checkout"
include Checkout

class CheckoutTests < Test::Unit::TestCase
  def setup
    @price_rules = [
      PriceRule.new("Apple") {|qty| qty * 0.5},
      PriceRule.new("Apple") { |qty| (qty/3) * -0.2 },
      PriceRule.new("Orange") { |qty| qty * 0.8},
      PriceRule.new("Orange") { |qty| (qty/2) * -0.8 },
      PriceRule.new("Banana") { |qty| qty * 1.0},
      PriceRule.new("Banana") { |qty| (qty/2) * -0.5 }
    ]

    @transaction = Transaction.new(formatter: NullFormatter.new, price_rules: @price_rules)
  end

  def test_can_create_transaction_with_price_rule
    t = Transaction.new(price_rules:[PriceRule.new("")])
    assert(t.price_rules.count > 0, "Expected price rules")
  end

  def test_can_add_item
    @transaction.add_item("Apple")
    assert(@transaction.items.count > 0, "Expected items")
  end

  def test_price_for_one_apple
    @transaction.add_item("Apple")
    @transaction.checkout
    assert_equal(0.5,@transaction.total)
  end

  def test_price_for_three_apples
    @transaction.add_item("Apple")
    @transaction.add_item("Apple")
    @transaction.add_item("Apple")
    @transaction.checkout
    assert_equal(1.30,@transaction.total)
  end

  def test_buy_one_get_one_free
    @transaction.add_item("Orange")
    @transaction.add_item("Orange")
    @transaction.checkout
    assert_equal(0.8,@transaction.total)
  end

  def test_buy_one_get_one_half_off
    @transaction.add_item("Banana")
    @transaction.add_item("Banana")
    @transaction.checkout
    assert_equal(1.5,@transaction.total)
  end

  def test_money_format
    assert_equal("$10.99",Checkout.money_format(10.994))
  end

  def test_formatter_prints_price_quantity_and_name
    f = Formatter.new
    name = "TestName"
    quantity = 5
    price = 10.0
    line_item = f.line_item(name,quantity,price)
    assert_match(name,line_item)
    assert_match("#{quantity}",line_item)
    assert_match(Checkout.money_format(price),line_item)
  end

  def test_formatter_prints_discount_for_negative_values
    f = Formatter.new
    name = "TestName"
    quantity = 5
    price = -10.0
    line_item = f.line_item(name,quantity,price)
    assert_match("-$10.00",line_item)
  end
end

class NullFormatter
  def total (total)
  end
  def line_item (name,qty,price)
  end
end
