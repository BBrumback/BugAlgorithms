#include "BugAlgorithms.hpp"
#include <iostream>
#include <cmath>

BugAlgorithms::BugAlgorithms(Simulator * const simulator)
{
    m_simulator = simulator;   
    //add your initialization of other variables
    //that you might have declared
    
    m_mode = STRAIGHT;
    m_hit[0] = m_hit[1] = HUGE_VAL;
    m_leave[0] = m_leave[1] = 0;
    m_distLeaveToGoal = HUGE_VAL;    
}

BugAlgorithms::~BugAlgorithms(void)
{
    //do not delete m_simulator  
}

Move BugAlgorithms::Bug0(Sensor sensor)
{
    //add your implementation
    Move move ={0.0, 0.0};
    double stay_flag = dotProduct(moveToGoal(), moveToObstacle(sensor));

    if(m_mode == STRAIGHT){
      if(sensor.m_dmin > m_simulator->GetWhenToTurn() && stay_flag<0){
	move = moveToGoal();
      }else{
	m_mode = AROUND;
	m_hit[0] = sensor.m_xmin;
	m_hit[1] = sensor.m_ymin;
      }
    //Move around obstacle
    } else if (m_mode == AROUND){
      if(stay_flag>0){
	move = moveAround(sensor);
      }else{
	m_mode = STRAIGHT;
	m_leave[0] = sensor.m_xmin;
	m_leave[1] = sensor.m_ymin;
      }
    //Error case  
    } else {
      //m_mode = STRAIGHT;
      //std::cout << "SOMETHING WENT WRONG";
    }
    return move;
}

Move BugAlgorithms::Bug1(Sensor sensor)
{
    //add your implementationGetStep()};
  
    Move move ={0,0};

    return move;
}

Move BugAlgorithms::Bug2(Sensor sensor)
{
   
  //add your implementation
  Move move ={0,0};
   
  return move;
}
 
double BugAlgorithms::distance(double x1, double y1, double x2, double y2)
{
  double deltaX = x2 - x1;
  double deltaY = y2 - y1;
  
  return std::sqrt(deltaX * deltaX + deltaY * deltaY);
}

Move BugAlgorithms::moveToGoal(void)
{
  double moveX = m_simulator->GetGoalCenterX() - m_simulator->GetRobotCenterX();
  double moveY = m_simulator->GetGoalCenterY() - m_simulator->GetRobotCenterY();
  return norm((Move){moveX, moveY});
}

Move BugAlgorithms::moveAround(Sensor sensor /*add in option to go direction*/)
{
  double moveX = sensor.m_xmin - m_simulator->GetRobotCenterX();
  double moveY = sensor.m_ymin - m_simulator->GetRobotCenterY();
  if(true)
    return norm((Move){-moveY, moveX});
  else
    return norm((Move){moveY, -moveX});  
}

Move BugAlgorithms::moveToObstacle(Sensor sensor)
{
  double moveX = sensor.m_xmin - m_simulator->GetRobotCenterX();
  double moveY = sensor.m_ymin - m_simulator->GetRobotCenterY();
  return norm((Move){moveX, moveY});  
}

//Takes the dot product of two moves
double BugAlgorithms::dotProduct(Move move1, Move move2)
{
  double val = move1.m_dx * move2.m_dx + move1.m_dy * move2.m_dy;
  //std::cout << val;
  return val;
}

//Move to the goal
// Normalize the distance of the vector from pos to goal based on step
Move BugAlgorithms::norm(Move move)
{
  double length = std::sqrt(move.m_dx * move.m_dx + move.m_dy * move.m_dy);
  return (Move){(move.m_dx/length) * m_simulator->GetStep(), (move.m_dy/length) * m_simulator->GetStep()};
}

