#pragma once

enum Direction
{
    SOUTH,
    NORTH
};
class Rover
{
public:
    Rover(int x, int y, Direction direction)
    : m_x(x)
    , m_y(y)
    , m_direction(direction)
    {}


    int getXPosition()
    {
        return m_x;
    }

    int getYPosition()
    {
        return m_y;
    }

    Direction getDirection()
    {
        return m_direction;
    }
private:
    int m_x;
    int m_y;
    Direction m_direction;
};