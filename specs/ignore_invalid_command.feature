Feature: Ignoring invalid commands

  The rover only responds to valid commands: F, B, L, and R.
  Any other characters in a command sequence are ignored.

  Scenario: Ignoring invalid characters in a command sequence
    Given a rover is initialised at position (1, 1) facing North
    When the rover receives the command sequence "FXRZB"
    Then the rover should be at position (0, 2)
    And the rover should be facing East