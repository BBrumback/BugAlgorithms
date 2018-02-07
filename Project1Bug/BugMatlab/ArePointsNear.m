function [near] = ArePointsNear(pt1, pt2)
    near = norm(pt1 - pt2) < 0.8;
end
