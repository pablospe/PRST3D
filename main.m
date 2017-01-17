%% load env
clearvars; close all

%% load reconstruction
V  = loadFromDataFile('chair04_cutout_grad.dat');
plot_volume(V);


%% find_symmetries
n_samples = 2000;

% sampling orientation (in degree)
theta_spacing = 2;

% sampling orientation (in degree)
phi_spacing = 2;

% sampling translation
rho_spacing = 1;

% hough space max. domain value
th_max = 180;
phi_max = 180;

% find peaks parameters
min_height = 0.5;
min_dist = 0.5;

% type = 'vertical';
type = 'all';
[hough_space, locs, sym] = ...
    find_symmetries(V, theta_spacing, phi_spacing, rho_spacing, ...
                    n_samples, th_max, phi_max, min_height, min_dist, type);


%% find peaks (non-maximum suppression)
% This is also inside 'find_symmetries()', but it has been copied here to give
% more control over the non-maximum suppression parameters, without recomputing.

sz = size(V);
use_dim = true(1, ndims(hough_space));

hough = hough_space ./ max(hough_space(:));
min_height = 0.3;       % percent
min_dist = sz(1) * 0.3; % percent

tic;
p = findpeaksn(hough, use_dim, min_height, min_dist);
toc

locs = find(p);
[~,I] = sort(hough(locs), 'descend');
locs = locs(I);



%% plot symmetries

% r_max = n*sqrt(2)
sz = size(V);
r_max = round(max(sz) * sqrt(2));

% rho, theta and phi domains
rho_domain = -r_max:rho_spacing:r_max;
th_domain  = deg2rad(0:theta_spacing:th_max);
phi_domain = deg2rad(0:phi_spacing:phi_max);

figure(1); clf
for i_peak = 1:length(locs)
    [i,j,k] = ind2sub(size(hough_space), locs(i_peak));

    PRST = hough_space(i,j,k);
    rho = rho_domain(i);
    th = th_domain(j);
    phi = phi_domain(k);

    fprintf('PRST=%.2f, rho = %d, th = %d, phi = %d\n', ...
             PRST, rho, rad2deg(th_domain(j)), rad2deg(phi_domain(k)))

    % volume with plane
    figure(1);
%     clf
    plot_volume_with_plane(V,rho,th,phi)

    % plane with support
    figure(2);
    clf;
    plot_support(V, rho, th, phi);
    view([-70,25])

    if (length(locs) > 1)
        % pause(0.3)
        pause
    end
end
