#include <gtest/gtest.h>
#include "rover.h"


TEST(initialaise, initialise_position)
{
    Rover rover(2,3, NORTH);
    EXPECT_EQ( (Coordinates{2,3}), rover.getPosition());    
}

TEST(initialise, intialise_direction)
{
    Rover rover(2,3, NORTH);
    EXPECT_EQ(NORTH, rover.getDirection());
}