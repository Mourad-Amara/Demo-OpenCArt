Feature: Cart Management

  As a user, I want to manage items in my shopping cart so that I can purchase the products I need.

  @Cart @DDT @Positive @Medium
  Scenario Outline: Add a product to the cart
    Given I am on the product page for "<product>"
    When I click the "Add to cart" button
    Then the cart summary should show "<expected_message>."

    Examples:
      | product   | expected_message             |
      | Laptop    | 1 item(s) in your cart.      |
      | Phone     | 1 item(s) in your cart.      |
      | Camera    | 1 item(s) in your cart.      |
      | Headphones| 1 item(s) in your cart.      |
      
       @Cart @DDT @Negative @ErrorHandling @Boundary
  Scenario Outline: Add a product to the cart without stock
    Given I am on the product page for "<product>"
    When I click the "Add to cart" button
    Then I should see the message "<error_message>."

    Examples:
      | product       | error_message                   |
      | Camera        | This product is out of stock.    |
      | Headphones    | This product is out of stock.    |
      | Watch         | This product is out of stock.    |
      | Tablet        | This product is out of stock.    |
      
       @Cart @DDT @Positive @Medium
  Scenario Outline: Update the quantity of an item in the cart
    Given I have "<product>" in my cart
    When I update the quantity to "<quantity>"
    Then the cart summary should show "<summary>."

    Examples:
      | product   | quantity | summary                      |
      | Laptop    | 2        | 2 item(s) in your cart.      |
      | Phone     | 3        | 3 item(s) in your cart.      |
      | Camera    | 5        | 5 item(s) in your cart.      |
      | Headphones| 1        | 1 item(s) in your cart.      |
      
       @Cart @DDT @Positive @Medium
  Scenario Outline: Remove a product from the cart
    Given I have "<product>" in my cart
    When I click the "Remove" button next to "<product>"
    Then the cart summary should show "<summary>."

    Examples:
      | product    | summary                   |
      | Laptop     | Your cart is empty.        |
      | Phone      | Your cart is empty.        |
      | Camera     | Your cart is empty.        |
      | Headphones | Your cart is empty.        |
      
      @Checkout @DDT @Positive @Critical
  Scenario Outline: Checkout with multiple items in the cart
    Given I have the following items in my cart:
      | product   | quantity |
      | <product> | <quantity> |
    When I proceed to checkout
    Then I should see the order summary with "<product>" and "<quantity>."

    Examples:
      | product   | quantity |
      | Laptop    | 2        |
      | Phone     | 1        |
      | Camera    | 3        |
      | Headphones| 1        |
      
      @Cart @DDT @Negative @ErrorHandling @Boundary
  Scenario Outline: Attempt checkout with an empty cart
    Given I have no items in my cart
    When I proceed to checkout
    Then I should see the message "Your cart is empty."

    Examples:
      | cart_empty |
      | Yes        |
      | No         |
      
      @Cart @DDT @Negative @Boundary
  Scenario Outline: Attempt to update quantity to zero
    Given I have "<product>" in my cart
    When I update the quantity to "0"
    Then I should see the message "Quantity cannot be zero or negative."

    Examples:
      | product   |
      | Laptop    |
      | Phone     |
      | Camera    |
      | Headphones|
      
      @Cart @DDT @Negative @ErrorHandling
  Scenario Outline: Attempt to update quantity with invalid input
    Given I have "<product>" in my cart
    When I update the quantity to "<invalid_quantity>"
    Then I should see the message "Invalid quantity."

    Examples:
      | product    | invalid_quantity |
      | Laptop     | -1               |
      | Phone      | 0                |
      | Camera     | 9999999          |
      | Headphones | abc              |
      
       @Cart @DDT @Positive @Medium
  Scenario Outline: Verify the cart summary after adding, updating, or removing items
    Given I have "<product>" in my cart
    When I add "<additional_product>" to my cart
    And I update the quantity of "<product>" to "<quantity>"
    And I remove "<remove_product>" from my cart
    Then the cart summary should show "<final_summary>."

    Examples:
      | product   | additional_product | quantity | remove_product | final_summary                          |
      | Laptop    | Phone              | 2        | Camera         | 2 item(s) in your cart.                |
      | Phone     | Camera             | 3        | Headphones     | 3 item(s) in your cart.                |
      | Camera    | Headphones         | 1        | Laptop         | 1 item(s) in your cart.                |
      | Headphones| Laptop             | 5        | Phone          | 5 item(s) in your cart.                |
      
      @Checkout @DDT @Positive @Critical
  Scenario Outline: Proceed to checkout with multiple items in the cart
    Given I have the following items in my cart:
      | product   | quantity |
      | <product> | <quantity> |
    When I proceed to checkout
    Then I should be able to complete the checkout with "<quantity>" of "<product>."

    Examples:
      | product   | quantity |
      | Laptop    | 2        |
      | Phone     | 1        |
      | Camera    | 3        |
      | Headphones| 5        |
      
      