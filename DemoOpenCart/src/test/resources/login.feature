Feature: Login and Logout
  As a user of the OpenCart demo site
  I want to securely log in and log out of my account
  So that I can access and protect my personal information

  @Login @Positive @Smoke @DDT
  Scenario Outline: Successful login with valid credentials
    Given I am on the login page
    When I enter username "<username>" and password "<password>"
    And I click the login button
    Then I should see the message "Welcome back, <username>!"

    Examples:
      | username                | password   |
      | valid_user1@example.com | password1  |
      | valid_user2@example.com | password2  |

  @Login @Negative @Regression @DDT
  Scenario Outline: Login attempt with invalid credentials
    Given I am on the login page
    When I enter username "<username>" and password "<password>"
    And I click the login button
    Then I should see the message "Invalid username or password."

    Examples:
      | username                  | password   |
      | invalid_user@example.com  | password1  |
      | valid_user1@example.com   | wrongpass  |
      | invalid_user@example.com  | wrongpass  |

  @Login @Negative @Boundary @DDT
  Scenario Outline: Login attempt with empty fields
    Given I am on the login page
    When I enter username "<username>" and password "<password>"
    And I click the login button
    Then I should see the message "Username and password are required."

    Examples:
      | username | password |
      |          |          |
      |          | demo123  |
      | demo_user@example.com |          |

  @Login @Negative @Boundary @DDT
  Scenario Outline: Login attempt with a locked user account
    Given I am on the login page
    When I enter username "<username>" and password "<password>"
    And I click the login button
    Then I should see the message "Your account is locked. Please contact support."

    Examples:
      | username                  | password   |
      | locked_user@example.com   | password1  |
      | locked_user@example.com   | wrongpass  |

  @Login @Negative @ErrorHandling
  Scenario: Login attempt with SQL injection
    Given I am on the login page
    When I enter username "admin' OR '1'='1" and password "password"
    And I click the login button
    Then I should see the message "Invalid username or password."

  @Logout @Smoke @Positive
  Scenario: User logs out successfully
    Given I am logged into my account
    When I click the logout button
    Then I should be redirected to the login page
    And I should see the message "You have been logged out successfully."

  @Logout @Negative @Boundary
  Scenario: Logout attempt without an active session
    Given I am not logged into my account
    When I try to access the logout page
    Then I should be redirected to the login page
    And I should see the message "Please log in to continue."

  @Login @Negative @Security @Regression
  Scenario: Login attempt with a script injection
    Given I am on the login page
    When I enter username "<script>alert('hack')</script>" and password "<password>"
    And I click the login button
    Then I should see the message "Invalid username or password."