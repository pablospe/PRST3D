function f_refl = find_reflected_volume(f, rho, th, phi)
    n = size(f);
    f_refl = zeros(n);

    % find points where f is not '0'
    k = find(f);
    [x,y,z] = ind2sub(n, k);
    n_pts = length(k);

    for k = 1:n_pts
        x_refl = find_reflection_point([x(k);y(k);z(k)], rho, th, phi);
        x_refl = round(x_refl);

        if is_inside_image(x_refl, n)
%             f(x(k),y(k),z(k))
            f_refl(x_refl(1),x_refl(2),x_refl(3)) = f(x(k),y(k),z(k));
        end
    end
end
