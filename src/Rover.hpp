#pragma once

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