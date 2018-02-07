function [] = RunBug(fname, option)
% RunBug(fname, option)
%  - fname: name of obstacle file
%  - option: 0, 1, 2 to indicate choice of bug algorithm 

   % Setup figure environment

   clf;
   figure;
   set(gca, 'xlim', [-22.5 22.5]); 
   set(gca, 'ylim', [-18.5 18.5]);
   grid on;
   hold on;   

   % Read and draw obstacle polygons.
   % File starts with the overall number of polygons.
   % Each polygon is then specified by providing first the number of vertices, nv, 
   % and then all the polygon vertices, where each polygon vertex is specified by giving its x and y values. 

   in = fopen(fname,'r');   
   nrPolys = fscanf(in, '%d', [1 1]);
   for i = 1 : 1 : nrPolys
       nv = fscanf(in, '%d', [1 1]);
       poly = zeros(1, nv);
       for j = 1 : 1 : 2 * nv
           poly(j) = fscanf(in, '%f', [1 1]);
       end
       polys{i} = poly;
       fill(poly(1:2:2*nv), poly(2:2:2*nv),'b');
   end
   fclose(in);

   % Allow the user to set robot and goal center

   fprintf('click to enter robot center...\n');
   robotCenter = ginput(1);   
   plot(robotCenter(1), robotCenter(2), 'ro', 'LineWidth', 3);
   fprintf('click to enter goal center...\n');
   goalCenter  = ginput(1);
   plot(goalCenter(1), goalCenter(2), 'go', 'LineWidth', 10);

   prev = robotCenter;
   robotInit = robotCenter;

   
   params.whenToTurn  = 1.0;         % value to determine when  to follow obstacle boundary
   params.step        = 0.15;        % step length that the robot can take
   params.mode        = 'Straight';  % operating mode for the robot -- initially, it should move straight 
   params.hit         = [0 0];       % store the hit point  
   params.leave       = [0 0];       % store the leave point
   params.distLeaveToGoal = inf;     % distance from leave point to goal    

   while 1
       sensor = TakeSensorReading(polys, robotCenter);

       if option == 0
	   [move, params] = Bug0(polys, robotInit, robotCenter, goalCenter, params, sensor);
       elseif option == 1
	   [move, params] = Bug1(polys, robotInit, robotCenter, goalCenter, params, sensor);
       else
	   [move, params] = Bug2(polys, robotInit, robotCenter, goalCenter, params, sensor);
       end
       
      robotCenter = robotCenter + move;
      line([prev(1), robotCenter(1)], [prev(2), robotCenter(2)], 'LineWidth', 2, 'Color', [1 0 0]);
      prev = robotCenter;
      if ArePointsNear(robotCenter, goalCenter) == 1
            msgbox('Robot reached goal!', 'Done');
            return;
      end
      drawnow;
   end
end
