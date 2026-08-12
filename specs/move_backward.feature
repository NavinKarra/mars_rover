Feature: Moving the Mars Rover backward

  The rover moves one grid unit opposite to the direction it is currently facing when receiving a 'B' command.

  Scenario Outline: Moving backward changes position opposite to heading
    Given a rover is initialised at position (1, 1) facing <direction>
    When the rover receives the command "B"
    Then the rover should be at position <expected_position>

    Examples:
      | direction | expected_position |
      | North     | (1, 0)            |
      | East      | (0, 1)            |
      | South     | (1, 2)            |
      | West      | (2, 1)            |