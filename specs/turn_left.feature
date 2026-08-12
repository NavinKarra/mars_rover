Feature: Turning the Mars Rover left

  The rover rotates 90 degrees anti-clockwise when receiving an 'L' command.
  Only the heading changes; position remains unchanged.

  Scenario Outline: Turning left updates the rover heading
    Given a rover is initialised facing <start_direction>
    When the rover receives the command "L"
    Then the rover should be facing <end_direction>

    Examples:
      | start_direction | end_direction |
      | North           | West          |
      | West            | South         |
      | South           | East          |
      | East            | North         |