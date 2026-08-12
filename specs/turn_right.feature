Feature: Turning the Mars Rover right

  The rover rotates 90 degrees clockwise when receiving an 'R' command.
  Only the heading changes; position remains unchanged.

  Scenario Outline: Turning right updates the rover heading
    Given a rover is initialised facing <start_direction>
    When the rover receives the command "R"
    Then the rover should be facing <end_direction>

    Examples:
      | start_direction | end_direction |
      | North           | East          |
      | East            | South         |
      | South           | West          |
      | West            | North         |