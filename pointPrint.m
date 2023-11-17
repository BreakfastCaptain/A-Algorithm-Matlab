function pointPrint(point,target_point_x,target_point_y)
    % Define a temporary node to hold information about the parent node
	tempPoint = point(target_point_x,target_point_y);  
    path = [];   
    while ~isempty(tempPoint.parent)
        tempPoint = tempPoint.parent;
		tempX = tempPoint.xCoordinate;
        tempY = tempPoint.yCoordinate; 
        disp("("+tempX+","+tempY+")");
		point(tempX,tempY).iskeyPoint = true;
        path = [path;tempX,tempY];   
    end
    
	% Output map situation
    % 0 black, 1 white, 2 red, 3 green, 4 blue
    colormap([0 0 0;1 1 1;1 0 0;0 1 0;0 0 1]);
    map = ones(size(point,1),size(point,2));
	for i = 1:size(map,1)     
		for j = 1:size(map,2) 
            if point(i,j).isStartPoint
				map(i,j) = 2;   % Starting point in red
            elseif point(i,j).isEndPoint
    		    map(i,j) = 2;   % End point in red
            elseif point(i,j).isObstacle
				map(i,j) = 0;   % Obstacle points in black
            elseif point(i,j).isCloseList || point(i,j).isOpenList 
                map(i,j) = 4;   % Extension points in blue
            else
                map(i,j) = 1;   % Ordinary points in white
            end
        end
    end

    map(i+1,j+1) = 5;   % extend the map by one frame
   
    pcolor(map);    
    set(gca,'XTick',1:size(map,2)-1,'YTick',1:size(map,1)-1);  
    axis image xy;     
    
    hold on; 
    
    t =text(j+2,i,'Start & Target Points');  
    t.BackgroundColor = 'r';
     t.FontWeight = 'bold' ;

    t =text(j+2,i*3/4,'Obstacle Points');
    t.BackgroundColor =[0 0 0];
    t.FontWeight = 'bold' ;
    t.Color = [1 1 1];

    t =text(j+2,i/2,'Path Points');
    t.BackgroundColor ='g';
    t.FontWeight = 'bold' ;
    
    t =text(j+2,i/4,'Extension Points');
    t.BackgroundColor = 'b';
    t.FontWeight = 'bold' ;
  

    for i = flip(1:size(path,1)-1)
        x = path(i,1);
        y = path(i,2);
        fill([y,y+1,y+1,y],[x,x,x+1,x+1],'g'); 
        pause(0.5); 
    end
    hold off
  
end

