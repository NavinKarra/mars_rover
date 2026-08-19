struct Coordinates {
    int x;
    int y;
    
    bool operator==(const Coordinates& other) const {
        return x == other.x && y == other.y;
    }
};

enum Direction {
    NORTH,
};
class Rover {
    private:
        Coordinates m_coordinates;
        Direction m_direction;

    public:
    
        Rover(int x,int y, Direction direction) {
            m_coordinates.x = x;
            m_coordinates.y = y;
            m_direction = direction;

        }
        Coordinates getPosition() {
            return m_coordinates;
        }

        Direction getDirection(){
            return m_direction;
        }
};