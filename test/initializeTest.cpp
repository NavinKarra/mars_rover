#include "gtest/gtest.h"

class Rover
{
public:
    Rover(int x)
    : m_x(x)
    {}


    int getXPosition()
    {
        return m_x;
    }
private:
    int m_x;
};



TEST(InitializeRover, SuccessfulInitialization)
{
    Rover rover(3);
    EXPECT_EQ(rover.getXPosition(), 3);
}

