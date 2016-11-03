function [hough_space, locs, sym] = ...
    find_symmetries(V, theta_spacing, phi_spacing, rho_spacing, ...
                    n_samples, th_max, phi_max, ...
                    min_height, min_dist, type)

if ~exist('type','var'), type = ''; end

%% Compute PRST
    % random sampling
    % profile on
    tic
    hough_space = compute_PRST_random_sampling(V, rho_spacing, ...
                                               theta_spacing, ...
                                               phi_spacing, n_samples, ...
                                               th_max, phi_max, type);

    toc
    % profile viewer
    % profsave

    % Saving hough space
    % c = uint32(clock);
    % str = sprintf('hough_space_%d-%.2d-%.2d_%.2d-%.2d-%.2d.mat', c(1), c(2), c(3), c(4), c(5), c(6));
    % save(str, 'hough_space','V', 'min_height', 'min_dist', ...
    %           'rho_spacing', 'theta_spacing', 'phi_spacing');

%% Find peaks
    use_dim = true(1, ndims(hough_space));
    hough = hough_space ./ max(hough_space(:));
    sz = size(V);
    p = findpeaksn(hough, use_dim, min_height, sz(1)*min_dist);
    locs = find(p);

    % sort (important first)
    [~,I] = sort(hough(locs), 'descend');
    locs = locs(I);

%% Get symmetries
    % r_max = n*sqrt(2)
    r_max = round(max(sz) * sqrt(2));

    % rho, theta and phi domains
    rho_domain = -r_max:rho_spacing:r_max;
    th_domain  = deg2rad(0:theta_spacing:th_max);
    phi_domain = deg2rad(0:phi_spacing:phi_max);

    % weight, nx, ny, nz, d
    sym = zeros(length(locs),7);

    for i_peak = 1:length(locs)
        [i,j,k] = ind2sub(size(hough_space), locs(i_peak));

        PRST = hough_space(i,j,k);
        rho = rho_domain(i);
        th = th_domain(j);
        phi = phi_domain(k);

%         fprintf('PRST=%.2f, rho = %d, th = %d, phi = %d\n', ...
%                  PRST, rho, rad2deg(th_domain(j)), rad2deg(phi_domain(k)))

        normal = [sin(th)*cos(phi); sin(th)*sin(phi); cos(th)];

        % all symmetries (prepare to use save_symmetries function)
        sym(i_peak, :) = [PRST, normal(1), normal(2), normal(3), rho, th, phi];
    end
end
