%% load data
% load('nyu_depth_v2_labeled.mat')
root = '../nyu_indoor_scene_seg_sup/';
addpath(genpath(root))


%%
% 254 259 282 
i = 259;

figure(1)
subplot(1,2,1);
num = sprintf('%.6d', i);
load([root, 'labels_structure/labels_', num, '.mat']); % imgStructureLabelsOrig
imagesc(imgStructureLabelsOrig);
title('Support');


load([root, 'labels_objects/labels_', num, '.mat']);   % imgObjectLabels
load([root, 'labels_instances/labels_', num, '.mat']); % imgInstanceLabels
imgRegions = get_regions_from_labels(imgObjectLabels, imgInstanceLabels);

subplot(1,2,2);
% load(['regions/regions_from_labels_', num, '.mat'])
imagesc(imgRegions);
title('Regions (object segmentation)');


%% depth to point cloud
figure(2)
load([root, 'images_depth/depth_', num, '.mat']); % imgDepth

ImgL = imgRegions;
mask = ImgL == 20;
imagesc(mask);

% img_depth = ImgD;
img_depth = imgDepth;
img_depth(~mask) = -1;

% img_depth = zeros(size(mask));
% img_depth(mask) = ImgD(mask);
% img_depth(~mask) = -1;

% imagesc(img_depth)
xyzPoints = depth2pcl(img_depth);
plot_points(xyzPoints);

grid off;
axis off;
set(gcf,'color','w');

%% regionprops
% stats = regionprops(mask,'all');
% % stats(23)
% stats
% 
% N = size(stats,1)
% % imagesc(mask)
% for i=1:N
%     hold on
%     points = stats(i).Centroid;
%     plot(points(:,1), points(:,2), '*b')
%     hold off
% end

%
% pts = stats(1).BoundingBox;
% hold on
% % plot(pts(1), pts(2), '*r')
% plot(pts(1)+pts(3), pts(2)+pts(4), '*r')
% % hold off

% bb = stats(2).BoundingBox;
% rectangle('Position',[bb(1) bb(2) bb(3) bb(4)],'EdgeColor','green');


%% Points to Volumen
figure(3)
V = depth2volumen(img_depth);
plot_volume(V);
axis([0 sz(1) 0 sz(2) 0 sz(3)])
% axis square

xlabel('X'); ylabel('Y'); zlabel('Z');
axis square;
cameratoolbar('Show')
cameratoolbar('SetMode', 'orbit')
cameratoolbar('SetCoordSys','z')
view(-90, -40)

% grid off;
% axis off;
set(gcf,'color','w');

