Feature: Executing a sequence of commands

  The rover processes a string of commands one at a time, in order.
  Each command updates the rover state before the next is applied.

  Scenario: Executing a mixed sequence of movement and rotation commands
    Given a rover is initialised at position (1, 1) facing North
    When the rover receives the command sequence "FFRFF"
    Then the rover should be at position (3, 3)
    And the rover should be facing East