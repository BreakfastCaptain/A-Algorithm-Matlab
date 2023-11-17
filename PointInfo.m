classdef PointInfo
    % Class properties of the point
    properties
	  xCoordinate;	   
      yCoordinate;
      
      isStartPoint = false;    % Whether or not it is the starting point
	  isEndPoint   = false;    % Whether it is the end point or not
	  isObstacle   = false;    % Whether it is an obstacle or not   
	  isCloseList  = false;    % Whether it is in the closed table
	  isOpenList   = false;    % Whether the table is open
	  iskeyPoint   = false;    % Whether it is a point on the shortest path
	
	  g = Inf;    % g，the actual cost of the point to the point to be expanded
	  h = Inf;    % h，the estimated cost of the point to be extended to the endpoint
      
      parent;     % The parent node of the point
    end
    
    properties(Dependent)  % f=g+h，make it a separate property 
      f;
    end
    methods
      function value = get.f(obj)
          value = obj.g+obj.h;
      end
    end
end
