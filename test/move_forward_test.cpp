#include <gtest/gtest.h>
#include "rover.h"

TEST(test_move_forward, move_forward_facing_north)
{
    Rover rover(1,1,NORTH);
    rover.command("F");
    EXPECT_EQ((Coordinates {1,2}), rover.getPosition());
}