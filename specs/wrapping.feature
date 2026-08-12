Feature: Mars Rover east-west wrapping

    The rover crosses the east or west edge of the grid, its x coordinate
    wraps to the opposite side of the grid. The y coordinate and the rover's
    direction remain unchanged.

    Scenario: Crossing the eastern edge
      Given the rover is at position (4, 2) facing East
      When the rover moves forward
      Then the rover should be at position (0, 2) facing East

    Scenario: Crossing the western edge
      Given the rover is at position (0, 2) facing West
      When the rover moves forward
      Then the rover should be at position (4, 2) facing West

Feature: Mars Rover wraps North or South

    The rover crosses either pole, its y coordinate remains at the pole,
    its North/South direction is reversed, and its x coordinate is mirrored.

    The mirrored x coordinate is calculated by adding half the width of the
    grid, rounded to the nearest whole number, and wrapping the result using
    modulo arithmetic.

    Therefore:
    new_x = (old_x + round(5 / 2)) % 5

    Scenario: Crossing the North Pole
      Given the rover is at position (1, 4) facing North
      When the rover moves forward
      Then the rover should be at position (4, 4) facing South

    Scenario: Crossing the South Pole
      Given the rover is at position (2, 0) facing South
      When the rover moves forward
      Then the rover should be at position (0, 0) facing North