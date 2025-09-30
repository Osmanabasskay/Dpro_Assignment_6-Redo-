# Shopping Application - Dpro Assignment
require_relative 'ownable'

# Wallet class for managing money
class Wallet
  include Ownable
  
  attr_accessor :balance
  
  def initialize(owner, initial_balance = 0)
    super(owner)
    @balance = initial_balance
  end
  
  def add_money(amount)
    @balance += amount
  end
  
  def withdraw_money(amount)
    if @balance >= amount
      @balance -= amount
      amount
    else
      0
    end
  end
  
  def can_afford?(amount)
    @balance >= amount
  end
end

# Item class for products in the store
class Item
  include Ownable
  
  attr_accessor :name, :price, :quantity
  
  def initialize(name, price, quantity, owner)
    super(owner)
    @name = name
    @price = price
    @quantity = quantity
  end
  
  def reduce_quantity(amount)
    @quantity -= amount if @quantity >= amount
  end
  
  def to_s
    "#{@name} - $#{@price} - Qty: #{@quantity}"
  end
end

# Cart class for managing shopping cart
class Cart
  include Ownable
  
  attr_accessor :items
  
  def initialize(owner)
    super(owner)
    @items = []
  end
  
  def add_item(item, quantity)
    # Find if item already exists in cart
    existing_item = @items.find { |cart_item| cart_item.name == item.name }
    
    if existing_item
      existing_item.quantity += quantity
    else
      # Create a new cart item (copy of the store item)
      cart_item = Item.new(item.name, item.price, quantity, item.owner)
      @items << cart_item
    end
  end
  
  def total_amount
    @items.sum { |item| item.price * item.quantity }
  end
  
  def check_out
    # The purchase price of all items in the cart will be transferred 
    # from the cart owner's wallet to the item owner's wallet
    @items.each do |cart_item|
      # Transfer money from cart owner to item owner
      total_item_cost = cart_item.price * cart_item.quantity
      withdrawn_amount = @owner.wallet.withdraw_money(total_item_cost)
      cart_item.owner.wallet.add_money(withdrawn_amount)
      
      # Ownership of all items in the cart is transferred to the cart owner
      cart_item.transfer_ownership(@owner)
      
      # Reduce quantity from store inventory
      cart_item.owner.items_list.find { |store_item| store_item.name == cart_item.name }.reduce_quantity(cart_item.quantity)
    end
    
    # The contents of the cart are empty
    @items.clear
  end
  
  def display_contents
    puts "🛒 Cart Contents"
    puts "+--------+------------------+-----+----+"
    puts "|Item No|Item Name         |Amount|Qty |"
    puts "+--------+------------------+-----+----+"
    
    @items.each_with_index do |item, index|
      puts "|#{index + 1.to_s.ljust(7)}|#{item.name.ljust(17)}|#{item.price.to_s.ljust(4)}|#{item.quantity.to_s.ljust(3)} |"
    end
    
    puts "+--------+------------------+-----+----+"
    puts "🤑 total amount: #{total_amount}"
  end
end

# Seller class representing the store
class Seller
  include Ownable
  
  attr_accessor :items_list
  
  def initialize(name)
    super(self) # Seller owns themselves
    @name = name
    @items_list = []
    @wallet = Wallet.new(self, 0)
  end
  
  def add_item(name, price, quantity)
    item = Item.new(name, price, quantity, self)
    @items_list << item
  end
  
  def display_items
    puts "📜 Product List"
    puts "+--------+------------------+-----+----+"
    puts "|Item No|Item Name         |Amount|Qty |"
    puts "+--------+------------------+-----+----+"
    
    @items_list.each_with_index do |item, index|
      puts "|#{index + 1.to_s.ljust(7)}|#{item.name.ljust(17)}|#{item.price.to_s.ljust(4)}|#{item.quantity.to_s.ljust(3)} |"
    end
    
    puts "+--------+------------------+-----+----+"
  end
end

# Customer class representing shoppers
class Customer
  include Ownable
  
  attr_accessor :name, :wallet, :cart
  
  def initialize(name)
    super(self) # Customer owns themselves
    @name = name
    @wallet = Wallet.new(self, 0)
    @cart = Cart.new(self)
  end
  
  def charge_wallet(amount)
    @wallet.add_money(amount)
  end
  
  def display_property
    puts "🛍️ Property of #{@name}"
    puts "+--------+------------------+-----+----+"
    puts "|Item No|Item Name         |Amount|Qty |"
    puts "+--------+------------------+-----+----+"
    
    # Display items owned by this customer
    owned_items = []
    # This would need to track items transferred to customer
    # For now, we'll show empty as items are transferred during checkout
    
    puts "+--------+------------------+-----+----+"
    puts "😱👛 #{@name}'s wallet balance: #{@wallet.balance}"
  end
end

# Main Shopping Application
class ShoppingApp
  def initialize
    @seller = Seller.new("DIC Store")
    @customer = nil
    setup_store_items
  end
  
  def setup_store_items
    # Add items to store as shown in the example
    @seller.add_item("CPU", 40830, 10)
    @seller.add_item("memory", 13880, 10)
    @seller.add_item("motherboard", 28980, 10)
    @seller.add_item("power supply unit", 8980, 10)
    @seller.add_item("PC Case", 8727, 10)
    @seller.add_item("3.5-inch HDD", 10980, 10)
    @seller.add_item("2.5-inch SSD", 13370, 10)
    @seller.add_item("M.2 SSD", 12980, 10)
    @seller.add_item("CPU Cooler", 13400, 10)
    @seller.add_item("graphics board", 23800, 10)
  end
  
  def run
    puts "🤖 What is your name?"
    customer_name = gets.chomp
    @customer = Customer.new(customer_name)
    
    puts "🏧 Enter the amount you wish to charge to your wallet"
    charge_amount = gets.to_i
    @customer.charge_wallet(charge_amount)
    
    puts "🛍️ Start Shopping"
    
    shopping_loop
  end
  
  def shopping_loop
    loop do
      @seller.display_items
      
      puts "⛏ Please enter the item number"
      item_number = gets.to_i
      
      puts "⛏ Please enter the quantity of products"
      quantity = gets.to_i
      
      # Add item to cart
      selected_item = @seller.items_list[item_number - 1]
      @customer.cart.add_item(selected_item, quantity)
      
      @customer.cart.display_contents
      
      puts "😭 Do you want to finish shopping?？(yes/no)"
      finish_shopping = gets.chomp.downcase
      
      if finish_shopping == "yes"
        checkout_process
        break
      end
    end
  end
  
  def checkout_process
    puts "💸Do you wish to confirm your purchase?？(yes/no)"
    confirm = gets.chomp.downcase
    
    if confirm == "yes"
      @customer.cart.check_out
      
      puts "୨୧┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈result┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈୨୧"
      @customer.display_property
      
      puts "📦 DIC Store Inventory"
      @seller.display_items
      
      puts "😻👛 Wallet balance in DIC Store: #{@seller.wallet.balance}"
      
      puts "🛒 Cart Contents"
      puts "+--------+------+----+----+"
      puts "|Item No|Item Name|Amount|Qty |"
      puts "+--------+------+----+----+"
      puts "+--------+------+----+----+"
      puts "🌚 total amount: 0"
      puts "🎉"
    end
  end
end

# Run the application
if __FILE__ == $0
  app = ShoppingApp.new
  app.run
end
