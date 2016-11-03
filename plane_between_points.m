function [n_vec, d] = plane_between_points(p1,p2)
    % normal vector
    n_vec = (p2 - p1);
    n_vec = n_vec / norm(n_vec);

    % point in the line (middle point)
    p0 = (p1 + p2) / 2;

    % distance
    d = n_vec' * p0;
end
