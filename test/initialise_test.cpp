#include <gtest/gtest.h>

struct Coordinates {
    int x;
    int y;
    
    bool operator==(const Coordinates& other) const {
        return x == other.x && y == other.y;
    }
};
class Rover {
    private:
        Coordinates m_coordinates;
    public:
    
        Rover(int x,int y) {
            m_coordinates.x = x;
            m_coordinates.y = y;
        }
        Coordinates getPosition() {
            return m_coordinates;
        }
};
TEST(initialaise, initialise_position)
{
    Rover rover(2,3);
    EXPECT_EQ( (Coordinates{2,3}), rover.getPosition());    
}
