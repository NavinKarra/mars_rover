#include <gtest/gtest.h>
#include "rover.h"

TEST(test_move_forward, move_forward_facing_north)
{
    Rover rover(1,1,NORTH);
    rover.command("F");
    EXPECT_EQ((Coordinates {1,2}), rover.getPosition());
}

TEST(test_move_forward, move_forward_facing_east) {
    Rover rover(1,1,EAST);
    rover.command("F");
    EXPECT_EQ((Coordinates {2,1}), rover.getPosition());
}

TEST(test_move_forward, move_forward_facing_south) {

    Rover rover(1, 1, SOUTH);
    rover.command("F");
    EXPECT_EQ((Coordinates{1,0}), rover.getPosition());
}