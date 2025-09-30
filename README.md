# Dpro Shopping Application Assignment

This is the corrected implementation of the Dpro Ruby Object-Oriented Programming assignment.

## Structure

```
Dpro_Assignment_6/
├── lib/
│   ├── ownable.rb          # Ownable module for classes requiring ownership
│   └── shopping_app.rb     # Main shopping application
├── data.txt               # Evaluation data (from original assignment)
└── test_structure.rb      # Test script to verify structure
```

## Requirements Met

✅ **Include the Ownable module in all classes that require owner privileges**
- `Wallet`, `Item`, `Cart`, `Seller`, and `Customer` classes all include the `Ownable` module
- Located in `lib/ownable.rb` and properly required in `lib/shopping_app.rb`

✅ **Ensure that the purchase amount of all items in the cart is transferred from the cart owner's wallet to the item owner's wallet**
- Implemented in `Cart#check_out` method (lines 67-75)
- Money is withdrawn from cart owner's wallet and added to item owner's wallet

✅ **The owner rights of all items in the cart are transferred to the cart owner**
- Implemented in `Cart#check_out` method (line 78)
- `cart_item.transfer_ownership(@owner)` transfers ownership to cart owner

✅ **The contents of the cart should be empty**
- Implemented in `Cart#check_out` method (line 81)
- `@items.clear` empties the cart after successful purchase

## How to Run

```bash
cd Dpro_Assignment_6
ruby lib/shopping_app.rb
```

## Expected Behavior

The application follows the exact flow shown in the Dpro assignment guide:
1. Ask for customer name
2. Ask for wallet charge amount
3. Display product list
4. Allow adding items to cart
5. Show cart contents
6. Confirm purchase
7. Transfer money and ownership
8. Display results

## Key Features

- **Ownable Module**: Provides ownership functionality to all relevant classes
- **Cart Checkout**: Properly handles money transfer, ownership transfer, and cart emptying
- **Inventory Management**: Tracks item quantities in store
- **Wallet System**: Manages customer and store balances
- **Interactive Interface**: Matches the expected user experience from the assignment guide
