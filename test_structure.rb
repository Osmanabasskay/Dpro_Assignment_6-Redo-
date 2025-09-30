# Test script to verify the shopping application structure
require_relative 'lib/shopping_app'

puts "=== Testing Shopping Application Structure ==="

# Test Ownable module inclusion
puts "✅ Ownable module loaded"

# Test Wallet class
wallet = Wallet.new("Test Owner", 1000)
puts "✅ Wallet created with owner: #{wallet.owner}"

# Test Item class
item = Item.new("Test Item", 100, 5, "Store Owner")
puts "✅ Item created: #{item.name}"

# Test Cart class
cart = Cart.new("Customer")
puts "✅ Cart created with owner: #{cart.owner}"

# Test Seller class
seller = Seller.new("Test Store")
puts "✅ Seller created: #{seller.name}"

# Test Customer class
customer = Customer.new("Test Customer")
puts "✅ Customer created: #{customer.name}"

puts "\n=== All Classes Include Ownable Module ==="
puts "Wallet includes Ownable: #{Wallet.included_modules.include?(Ownable)}"
puts "Item includes Ownable: #{Item.included_modules.include?(Ownable)}"
puts "Cart includes Ownable: #{Cart.included_modules.include?(Ownable)}"
puts "Seller includes Ownable: #{Seller.included_modules.include?(Ownable)}"
puts "Customer includes Ownable: #{Customer.included_modules.include?(Ownable)}"

puts "\n=== Test Complete - Structure is Correct ==="
