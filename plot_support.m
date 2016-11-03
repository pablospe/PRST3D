function plot_support(V, rho, th, phi)
    f = V; % paper convention
    limits = size(f);
    k = find(f);

%     plot_volume(f);
%     plot3(x, y, z, '.r');
    n_vec = [sin(th)*cos(phi); sin(th)*sin(phi); cos(th)];
    plot_plane(n_vec, rho, limits)
    f_refl = find_reflected_volume(f, rho, th, phi);

    hold on
    % find points where f is not '0'
    k_refl = find(f_refl);
    [x,y,z] = ind2sub(limits, k_refl);
    plot3(x, y, z, '.r');
    xlabel('x'); ylabel('y'); zlabel('z');

    % Support
    f_support = f*0.5 + f_refl*0.5;
    k_support = find(f_support==1);
    [x,y,z] = ind2sub(limits, k_support);
    plot3(x, y, z, 'og');

    hold off
end
