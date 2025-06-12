Feature: Student uploads info using course code

  Background:
    Given a user with full name "Prof A" exists and owns a course with code "AB12CD"

   Scenario: Happy path - Student submits valid data
    When the student visits "/students/new?code=AB12CD"
    And they fill in "First name" with "Alice"
    And they fill in "Last name" with "Zhao"
    And they upload a profile picture
    And they click "Submit"
    Then they should see "Dashboard"

  Scenario: Sad path - Student submits without required fields
    When the student visits "/students/new?code=AB12CD"
    And they click "Submit"
    Then they should see "First name and Last name can't be blank."
    And they should see "Upload a JPG or PNG image under 5MB."
