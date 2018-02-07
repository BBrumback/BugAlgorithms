function sensor = TakeSensorReading(polys, robotCenter)

 % Take sensor reading from robot center
 %   sensor.dmin : minimum distance from robot center to obstacle boundary
 %   sensor.xmin : x-coordinate of obstacle boundary point that is closest to robot center
 %   sensor.ymin : y-coordinate of obstacle boundary point that is closest to robot center
    
  sensor.dmin = Inf;
  n    = length(polys);
  for i = 1 : 1 : n
      [xmini, ymini, dmini] = PointPolygonDistanceSquare(robotCenter(1), robotCenter(2), polys{i});
      if (dmini < sensor.dmin)
          sensor.xmin = xmini;
          sensor.ymin = ymini;
          sensor.dmin = dmini;
      end
  end
end

function [xmin, ymin, dmin] = PointPolygonDistanceSquare(px, py, poly)
    n2                 = length(poly);
    [xmin, ymin, dmin] = PointSegmentDistanceSquare(px, py, poly(n2 - 1), poly(n2), poly(1), poly(2));
        for i = 1 : 2 : n2 - 3
        [xmini, ymini, dmini] = PointSegmentDistanceSquare(px, py, poly(i), poly(i+1), poly(i+2), poly(i+3));
        if (dmini < dmin)
            xmin = xmini;
            ymin = ymini;
            dmin = dmini;
        end
    end       
end

function [xmin, ymin, dmin] = PointSegmentDistanceSquare(px, py, s0x, s0y, s1x, s1y)
    vx = s1x - s0x;
    vy = s1y - s0y;
    wx = px  - s0x;
    wy = py  - s0y;
    a  = vx * wx + vy * wy;
    b  = vx * vx + vy * vy;
    
    if (a <= 0) 
        xmin = s0x;
        ymin = s0y;
        dmin = wx * wx + wy * wy;
        return;
    end
	
    if (b <= a)
        xmin = s1x;
        ymin = s1y;
        dmin = (px - s1x) * (px - s1x) + (py - s1y) * (py - s1y);
        return;
    end
    
    a = a ./ b;
    vx= s0x + a * vx;
    vy= s0y + a * vy;
    
    xmin = vx;
    ymin = vy;
    dmin = (px - vx) * (px - vx) + (py - vy) * (py - vy);    
end

