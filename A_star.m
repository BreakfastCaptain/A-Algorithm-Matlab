clear;
clc;
%% Step 1: Load the map and initialize the data settings
% Load the map
load('Map.mat');

% Get the number of rows and columns for the map
dimensions = size(Map);
numRows = dimensions(1); % 10
numCols = dimensions(2); % 10

% Set the coordinates of the start and target points
start_point_x=1;start_point_y=1;      % (1 ,1 )
target_point_x=10;target_point_y=10;  % (10,10)

%% Step 2: Create a PointInfo class based on the map information

point(numRows,numCols) = PointInfo;

% Define the starting point and the target point
point(start_point_x,start_point_y).isStartPoint = true;
point(target_point_x,target_point_y).isEndPoint = true;

% Set the coordinates and the information of the obstacle and H
for i = 1:numRows        	
    for j = 1:numCols
        % Coordinate settings
        point(i,j).xCoordinate = i;   
        point(i,j).yCoordinate = j;

        % H uses Manhattan distance
        point(i,j).h = 10*(abs(i-target_point_x) + abs(j-target_point_y) );  

        % According to the 0 1 information in the map, determine whether it is an obstacle or not
        if Map(i,j)==0
            point(i,j).isObstacle=false;  
        elseif Map(i,j)==1
            point(i,j).isObstacle=true;
        end
    end                                                                
end                                                                    
% The actual cost of g at the starting point is 0
point(start_point_x,start_point_y).g = 0; 

%% Step3 A* algorithm

openList = [];  % Extended Points
closeList = []; % Points not to be addressed
% Actual surrogate values set for the 8 neighbouring points of the current point
gCost = [14 10 14;10 0 10;14 10 14] ; 

% The endpoint is in the openList or the openList is empty, the algorithm ends
flag1 = false; 
flag2 = false;

% 1. Add the starting point to the openList
openList = [start_point_x,start_point_y,point(start_point_x,start_point_y).f]; 
point(start_point_x,start_point_y).isOpenList = true;

% 2. A* Loops
while ~flag1 && ~flag2
    % 3.Select the smallest f at the beginning of the open table.
    [~,I] = sort(openList(:,3));
    openList = openList(I,:);
    % 4. Move the point with the smallest F from openList to closedList.
    curX = openList(1,1);   
    curY = openList(1,2);
    point(curX,curY).isCloseList = true;
    point(curX,curY).isOpenList = false;
    closeList = [closeList;openList(1,:)];  
    openList(1,:)=[];
    % 5.Different actions are taken 
    % depending on whether the surrounding points are in the openList or not:
    for i = -1:1
        tempX = curX+i;  
        for j =-1:1
            tempY = curY+j;       
            if (tempX>=1) && (tempY>=1) && (tempX<=numRows) && (tempY<=numCols) && (~point(tempX,tempY).isObstacle) && (~point(tempX,tempY).isCloseList)
                % i. If the surrounding points are in the openList, 
                % check if the path is better, using the G-value as a reference
                 tempG = gCost(i+2,j+2)+point(curX,curY).g;  
                if point(tempX,tempY).isOpenList 
                    if tempG < point(tempX,tempY).g    
                        point(tempX,tempY).parent = point(curX,curY);  
						point(tempX,tempY).g = tempG;  
						[~,I] = sort(openList(:,3));  
                        openList = openList(I,:);
                    end
                % ii. If it is not in the openList, 
                % add it to the openList and set the current square as its father, 
                % recording the F, G and H values of that square.   
                else
                    point(tempX,tempY).g = tempG;       
					point(tempX,tempY).parent = point(curX,curY);
                    point(tempX,tempY).isOpenList = true;                   
                    openList = [openList;tempX,tempY,point(tempX,tempY).f]; 
                end
            end
        end
        % 6. Check if the endpoint is already in the openList or if the openList is empty.
        flag1 = point(target_point_x,target_point_y).isOpenList;
        flag2 = isempty(openList);
    end
end
 %% Step4 Output path

 % If flag1 is true, the shortest path is found
 % use pointPrint to output the route
if flag1   
    disp( "The total cost of the route is "+ point(target_point_x,target_point_y).f );
    disp("The route is (in reverse order):");
	pointPrint(point,target_point_x,target_point_y);
else
    disp("Path not found");
end
