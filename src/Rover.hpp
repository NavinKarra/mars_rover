#pragma once

class Rover
{
public:
    Rover(int x, int y)
    : m_x(x)
    , m_y(y)
    {}


    int getXPosition()
    {
        return m_x;
    }

    int getYPosition()
    {
        return m_y;
    }
private:
    int m_x;
    int m_y;
};