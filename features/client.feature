Feature: Sends log data securely
  
  Scenario: When I connect to an invalid host
    Given I have an invalid TLS endpoint
    When I connect to that endpoint
    Then the connection should fail due peer verification failure

  Scenario: When I connect to a valid host
    Given I have a valid TLS endpoint
    When I connect to that endpoint
    Then the connection should fail due peer verification failure