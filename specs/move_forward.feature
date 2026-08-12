Feature: Moving the Mars Rover forward

  The rover moves one grid unit in the direction it is currently facing when receiving an 'F' command.

  Scenario Outline: Moving forward changes position based on heading
    Given a rover is initialised at position (1, 1) facing <direction>
    When the rover receives the command "F"
    Then the rover should be at position <expected_position>

    Examples:
      | direction | expected_position |
      | North     | (1, 2)            |
      | East      | (2, 1)            |
      | South     | (1, 0)            |
      | West      | (0, 1)            |