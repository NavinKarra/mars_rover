Feature: Mars Rover obstacle avoidance

    Scenario: The rover stops before an obstacle
      Given the grid has an obstacle at position (2, 4)
      And the rover is at position (2, 2) facing North
      When the rover is given the commands "FF"
      Then the rover should finish at position (2, 3) facing North
      And the rover should notify us that an obstacle was encountered at (2, 4)