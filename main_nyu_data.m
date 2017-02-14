%% load data
% load('nyu_depth_v2_labeled.mat')
root = '../nyu_indoor_scene_seg_sup/';
addpath(genpath(root))


%%
% 254 259 282 
% i = 254;
% i = 259;
% i = 336;
i = 357;
% i = 282;
% % i = 878
% i = 672
% i = 556

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
mask = ImgL == 13;
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


%% Points to Volumen
figure(3)
V = depth2volumen(img_depth);
V = V(:,:,1:140);
plot_volume(V);
axis([0 sz(1) 0 sz(2) 0 sz(3)]);
% axis square

axis equal;
cameratoolbar('Show')
cameratoolbar('SetMode', 'orbit')
cameratoolbar('SetCoordSys','z')
view(-90, -40);

% grid off;
% axis off;
set(gcf,'color','w');
xlabel('X'); ylabel('Y'); zlabel('Z');


%%
figure(1)
clf
prop = 46;
structure = 227;
furniture = 144;
floor = 131;

Ic = imread('556.png');
I = Ic(:,:,1);
mask = I == 46;
mask = I == 144;
% mask = I==46 | I==144;
% imagesc(Ic)

maskI(:,:,1) = mask;
maskI(:,:,2) = mask;
maskI(:,:,3) = mask;
imagesc(uint8(maskI) .* Ic)

% imagesc(mask)

%
% regionprops
stats = regionprops(mask,'all');
% stats(23)
stats

N = length(stats)
% imagesc(mask)
for i=1:N
    hold on
    points = stats(i).Centroid;
    plot(points(:,1), points(:,2), '*r')
    hold off
end


% pts = stats(1).BoundingBox;
hold on
% plot(pts(1), pts(2), '*r')
% plot(pts(1)+pts(3), pts(2)+pts(4), '*r')
% hold off

for i=1:N
    if stats(i).Area < 2000
        continue;
    end
    if stats(i).Eccentricity > 0.1*9
        continue;
    end
    bb = stats(i).BoundingBox;
    rectangle('Position',[bb(1) bb(2) bb(3) bb(4)],'EdgeColor','green');
end

%%
N = length(stats)
value = zeros(1,N);
for i = 1:N
    value(i) = stats(i).Eccentricity;
end
figure(2)
plot(value)



%%
% export_fig('556_furniture','-png')

