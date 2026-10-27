Feature: initialize Mars rover
As the Rover operator, I want to intialize the Rover
so that I can set the position and direction of the Rover when it lands.

Scenario: Successful initialization
Given The System is prompting me to initialize the Rover with the message 
"Please enter x,y coordinates and direction to initialize the Rover with. E.g. 4,5,N"
When the operator enters "3,4,S"
Then The Rover is initialized at coordinates x=3, y=4 and facing South 
And The System confirms "The Rover has been initialized at (3,4) facing South"

