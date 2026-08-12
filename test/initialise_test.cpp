#include <gtest/gtest.h>
#include "rover.h"


TEST(initialaise, initialise_position)
{
    Rover rover(2,3);
    EXPECT_EQ( (Coordinates{2,3}), rover.getPosition());    
}
