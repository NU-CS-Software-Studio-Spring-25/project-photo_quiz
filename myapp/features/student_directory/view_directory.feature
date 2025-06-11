Feature: Viewing the student directory

  Scenario: Happy path - logged-in user sees dashboard
    When the user logs in as "professor@example.com" with password "password123"
    Then they should see "Dashboard"

  Scenario: Sad path - unauthenticated user tries to access directory
    When the student visits "/students"
    Then they should see "You need to sign in"
