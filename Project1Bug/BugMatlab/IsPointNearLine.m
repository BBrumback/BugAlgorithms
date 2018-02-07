function [near] = IsPointNearLine(p, line1, line2)
    % Determine if point p is near the line defined by its two endpoints line1, line2

    x    = line2(1) - line1(1);
    y    = line2(2) - line1(2);
    d    = (p(1) - line1(1)) * y - (p(2) - line1(2)) * x;
    near = d * d / (x * x + y * y) < 0.064;
end
