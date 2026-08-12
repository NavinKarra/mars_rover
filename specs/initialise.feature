Feature: Initialising the Mars Rover

  The rover is created with a starting position and heading.
  After initialisation, it should report the same position and heading.

  Scenario: Initialise rover at a given position and direction
    When the rover is initialised at position (2, 3) facing North
    Then the rover position should be (2, 3)
    And the rover heading should be North