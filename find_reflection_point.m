% theta (in radians)
function [x_reflexted, dist, x_intercep] = find_reflection_point(x, rho, th, phi)
    n_vec = [sin(th)*cos(phi); sin(th)*sin(phi); cos(th)];
    dist = (n_vec'*x - rho); % / sqrt(n_vec'*n_vec);
    x_intercep  = x - n_vec*dist;
    x_reflexted = x - n_vec*dist*2;
end
