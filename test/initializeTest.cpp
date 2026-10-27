#include "gtest/gtest.h"
#include "Rover.hpp"


TEST(InitializeRover, SuccessfulInitialization)
{
    Rover rover(3, 4);
    EXPECT_EQ(rover.getXPosition(), 3);
    EXPECT_EQ(rover.getYPosition(), 4);
}

