% load('nyu_depth_v2_labeled.mat')

% 254 259 282 

i = 259;
% i = 878;

% figure(1)
% subplot(1,3,1)
% Img = images(:,:,:,i);
% imagesc(Img)
% 
% subplot(1,3,2)
% ImgD = depths(:,:,i);
% imagesc(ImgD)
% 
% subplot(1,3,3)
% ImgL = labels(:,:,i);
% imagesc(ImgL)


%%
% imagesc(imgStructureLabelsOrig)
% imagesc(imgInstanceLabelsOrig)
% imagesc(imgObjectLabels)
% imagesc(imgDepthOrig)
% imagesc(planeData)
% imagesc(imgRegions)
% imagesc()

%%
figure(2)

root = '../nyu_indoor_scene_seg_sup/';
addpath(genpath(root))

% for i = 1:1449
% i = 259
num = sprintf('%.6d', i)
load([root, 'labels_structure/labels_', num, '.mat'])
imagesc(imgStructureLabelsOrig)

load([root, 'labels_objects/labels_', num, '.mat'])
load([root, 'labels_instances/labels_', num, '.mat'])
imgRegions = get_regions_from_labels(imgObjectLabels, imgInstanceLabels);

% load(['regions/regions_from_labels_', num, '.mat'])
imagesc(imgRegions)


load([root, 'images_depth/depth_', num, '.mat'])

% pause(0.2)
% end

%%
% % for i = 1:1449
% i = 915
% num = sprintf('%.6d', i)
% load(['regions_from_labels_', num, '.mat'])
% imagesc(imgRegions)


%%
% for i = 748:1449
% % i = 67
% num = sprintf('%.6d', i)
% load(['rgb_', num, '.mat'])
% imagesc(imgRgbOrig)
% % pause(0.2)
% imwrite(imgRgbOrig, ['rgb_', num, '.png'])
% end



%%
% imwrite(im2double(ImgL)*255, 'im.png')

%%
% img_depth = ImgD;
% xyzPoints = depth2pcl(img_depth);
% 
% %
% figure(2)
% plot_points(xyzPoints)

%%
% 936 941 943 949 955 1063 

% i = 1182
% % load(['../regions/regions_from_labels_00' sprintf('%.4d', i) '.mat'])
% % load('../regions/regions_from_labels_000909.mat')
% imagesc(imgRegions)



%%
figure(2)
% mask = imgRegions>2 & imgRegions<5;
% imagesc(mask)

ImgL = imgRegions;
mask = ImgL == 20;
imagesc(mask)

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

% img_depth = ImgD;
img_depth = imgDepth;
img_depth(~mask) = -1;

% img_depth = zeros(size(mask));
% img_depth(mask) = ImgD(mask);
% img_depth(~mask) = -1;

% imagesc(img_depth)
xyzPoints = depth2pcl(img_depth);
plot_points(xyzPoints)  

grid off;
axis off;
set(gcf,'color','w');


%%
% pts = stats(1).BoundingBox;
% hold on
% % plot(pts(1), pts(2), '*r')
% plot(pts(1)+pts(3), pts(2)+pts(4), '*r')
% % hold off

% bb = stats(2).BoundingBox;
% rectangle('Position',[bb(1) bb(2) bb(3) bb(4)],'EdgeColor','green');

%% points to volumen
% xyzPoints

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

%%

