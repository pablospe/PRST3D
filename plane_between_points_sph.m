function [rho, th, phi] = plane_between_points_sph(p1,p2)
    [n_vec, d] = plane_between_points(p1,p2);

    % sph coordinates: rho, th, phi
    th  = acos(n_vec(3)/sqrt(n_vec'*n_vec));
    phi = atan2(n_vec(2), n_vec(1));
    rho = d;
end
