function plot_plane(normal, r, limits, format)
    if ~exist('format','var'), format = 'b'; end

    % normalize
    normal = normal / norm(normal);

    % Find all coefficients of plane equathion
    A = normal(1); B = normal(2); C = normal(3);

    if abs(B) < 1e-6  % Y vertical plane
        d = abs(r);
        if abs(A)<1e-6 && abs(C)-1<1e-6
            x = [0 0 limits(1) limits(1)];
            y = [0 limits(2) limits(2) 0];
            z = [d d d d];
        elseif abs(C)<1e-6 && abs(A)-1<1e-6
            x = [d d d d];
            y = [0 0 limits(2) limits(2)];
            z = [0 limits(3) limits(3) 0];
        else
            if r/A < 0
                x = [(r-C*limits(3))/A (r-C*limits(3))/A 0 0];
                y = [0 limits(2) limits(2) 0];
                z = [limits(3) limits(3) r/C r/C];
            elseif r/C < 0
                x = [r/A r/A limits(1) limits(1)];
                y = [0 limits(2) limits(2) 0];
                z = [0 0 (r-A*limits(1))/C (r-A*limits(1))/C];
            else
                x = [r/A r/A 0 0];
                y = [0 limits(2) limits(2) 0];
                z = [0 0 r/C r/C];
            end
        end
        patch(x, y, z, format)
        alpha(0.5);
        axis([0 limits(1) 0 limits(2) 0 limits(3)])
        return
    end

    % Decide on a suitable showing range
    xLim = [0 limits(1)];
    zLim = [0 limits(3)];
    [X,Z] = meshgrid(xLim, zLim);

    % ax + by + cz = r
    Y = (A * X + C * Z - r) / (-B);
    reOrder = [1 2 4 3];
    patch(X(reOrder), Y(reOrder), Z(reOrder), format);
%     grid on;
    alpha(0.5);
    axis([0 limits(1) 0 limits(2) 0 limits(3)])
end
