% theta (in radians)
function x_refl = find_reflection_point_fast(x, rho, th, phi)
    n_vec = [sin(th)*cos(phi); sin(th)*sin(phi); cos(th)];
    dist = (n_vec(1)*x(1)+n_vec(2)*x(2)+n_vec(3)*x(3) - rho); % / sqrt(n_vec'*n_vec);
    x_refl = x - n_vec*dist*2;
end
