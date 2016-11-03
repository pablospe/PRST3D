function plot_volume(V)
    [X,Y,Z] = ind2sub(size(V), find(V(:)));
%     plot3(X,Y,Z,format);
    pcshow([X(:),Y(:),Z(:)], 'MarkerSize', 80)
end
