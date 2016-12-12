function plot_points(xyzPoints)
    pcshow(xyzPoints);
    xlabel('Y (m)'); ylabel('X (m)'); zlabel('Z (m)');
    axis square;
    cameratoolbar('Show')
    cameratoolbar('SetMode', 'orbit')
    % cameratoolbar('SetCoordSys','y')
    view(0, -70)
end