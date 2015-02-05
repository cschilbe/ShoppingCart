# Checkout Code Sample

## Description
This is a code sample for a checkout problem where items need to have an associated price 
and may have discounts applied based on quantity.

## Usage
You may execute the runner with a filename such as test_data.txt or by entering items on the command line
```
$ ruby checkout_runner.rb test_data.txt
```
```
$ ruby checkout_runner.rb
```

To run the unit tests, `$ ruby checkout_tests.rb`

## Requirements
- Items must be priced individually
- Application must be executable from the command line
- Application must accept input on command line or from file
- Application must accept items in any order
- Items should be collected as unordered list of single items
- Application should have checkout
- Application must print itemized receipt
- Application must print total
- Multiple price rules could be applied to a single item

## Solution
The solution builds rules at runtime using blocks to define the evaluation of the price rules.

Upon checkout all rules are run against all items in the cart, applying any rules which match the name. 

This solution could be extended to build rules from external sources such as YAML files or by implementing a DSL.

## Assumptions and caveats
- Floats are used for money which is bad but ok for demonstration
- Price rules could be further abstracted to common classes for quantity discount rules, per item price rules, etc. 
and built up instead of requiring essentially the same type of block for each.
- Classes are all in one file for simplicity
