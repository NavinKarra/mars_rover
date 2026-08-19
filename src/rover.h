#include <string>
struct Coordinates {
    int x;
    int y;
    
    bool operator==(const Coordinates& other) const {
        return x == other.x && y == other.y;
    }
};

enum Direction {
    NORTH,
    EAST,
    SOUTH,
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
        void command(std::string command){
            switch(m_direction)
            {
                case NORTH: 
                    m_coordinates.y +=1 ;
                    break;
                case EAST:
                    m_coordinates.x +=1;
                    break;
                case SOUTH:
                    m_coordinates.y -=1;
                    break;
                default:
                    break;
            }
        }
};