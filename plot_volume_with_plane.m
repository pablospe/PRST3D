function plot_volume_with_plane(V,rho,th,phi)
    limits = size(V);
    elements = find(V);
    [x,y,z] = ind2sub(limits, elements);

    hold on
    pcshow([x(:),y(:),z(:)], 'MarkerSize', 80);
    normal = [sin(th)*cos(phi); sin(th)*sin(phi); cos(th)];
    plot_plane(normal, rho, limits);
    xlabel('x'); ylabel('y'); zlabel('z');
%     view([-70,25])

    hold off
%     title('plot symmetries')
end
