%% load env
% clearvars; close all

%% load reconstruction
% V  = loadFromDataFile('chair04_cutout_grad.dat');
plot_volume(V);

% %% Gradient
% kernel = zeros([3 3 3]);
% kernel(2,2,1) = -1; kernel(2,1,2) = -1; kernel(1,2,2) = -1;
% kernel(3,2,2) =  1; kernel(2,3,2) =  1; kernel(2,2,3) =  1;
% display(kernel)
% 
% Vgrad = convn(V, kernel, 'same');
% Vgrad = Vgrad ./ max(Vgrad(:));
% Vgrad(abs(Vgrad)<0.4) = 0;
% plot_volume(Vgrad);
% % V = Vgrad

%% find_symmetries
n_samples = 4000;

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
min_height = 0.6;
min_dist = 0.6;

% type = 'vertical';
type = 'horizontal';
% type = 'all';
[hough_space, locs, sym] = ...
    find_symmetries(V, theta_spacing, phi_spacing, rho_spacing, ...
                    n_samples, th_max, phi_max, min_height, min_dist, type);


%% plot 3D hough space
fig = figure(3);
clf

hough = hough_space ./ max(hough_space(:));
% all_values_sorted = unique(sort(hough(:)));

sz = size(V);
r_max = round(max(sz) * sqrt(2));
rho_domain = -r_max:rho_spacing:r_max;
th_domain  = deg2rad(0:theta_spacing:th_max);
phi_domain = deg2rad(0:phi_spacing:phi_max);

idx = find(hough(:));
PRST = hough(idx);
sz = length(idx);
[X,Y,Z] = ind2sub(size(hough), idx);

PRST(0 < PRST & PRST<0.4) = 0.04;

PRST = 1.35*PRST;
m = mean(PRST);
s = std(PRST);

% PRST_size = 4000*PRST;
PRST_size = 4000*(PRST.^2);
% PRST_size = 25*exp((PRST-m).^2/s);

scatter3(X, Y, Z, PRST_size, PRST / max(PRST(:)), '.');
colorbar
axis equal
% grid off
xlabel('\rho (rho)'); ylabel('\theta (theta)'); zlabel('\phi (phi)');

% view(az,el)
set(gca,'Ydir','Reverse')
set(gca,'Xdir','Reverse')


% X domain
step = round(length(rho_domain)/13);
domain = 1:step:length(rho_domain);
set(gca,'XTick', domain);
set(gca,'XTickLabel', rho_domain(domain)-5 );

% Y domain
step = round(length(th_domain)/6);
domain = 1:step:length(th_domain);
set(gca,'YTick', domain);
set(gca,'YTickLabel', rad2deg(th_domain(domain)) );

% Z domain
step = round(length(phi_domain)/6);
domain = 1:step:length(phi_domain);
set(gca,'ZTick', domain);
set(gca,'ZTickLabel', rad2deg(phi_domain(domain)) );

% axis square
axis equal
% view(az,el)


% Wait while the user does this.
interactive = true;
% interactive = false;
datacursormode on
dcm_obj = datacursormode(fig);
while(interactive)
    pause

    c_info = getCursorInfo(dcm_obj);
    % Make selected line wider
    i = c_info.Position(1);
    j = c_info.Position(2);
    k = c_info.Position(3);

    rho = rho_domain(i);
    th = th_domain(j);
    phi = phi_domain(k);

    fprintf('PRST = %f, rho = %d, th = %d, phi = %d\n', ...
             hough_space(i,j,k), rho, rad2deg(th), rad2deg(phi))

    figure(1)
    clf
    plot_volume_with_plane(V,rho,th,phi)
    % axis square;
    cameratoolbar('Show')
    cameratoolbar('SetMode', 'orbit')
    cameratoolbar('SetCoordSys','z')
    view(-90, -79)

    grid off;
    axis off;
    set(gcf,'color','w');
    
%     figure(2)
%     clf
%     plot_support(V, rho, th, phi);
%     view([-70,25])
end


%%
figure(1)
clf
plot_volume_with_plane(V,rho,th,phi)
% axis square;
cameratoolbar('Show')
cameratoolbar('SetMode', 'orbit')
cameratoolbar('SetCoordSys','z')
view(-90, -79)

grid off;
axis off;
set(gcf,'color','w');

%% 
export_fig('357_13_01', '-pdf', '-png')


