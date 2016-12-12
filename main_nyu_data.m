% load('nyu_depth_v2_labeled.mat')

% 254 259 282 

i = 282;

figure(1)
subplot(1,3,1)
Img = images(:,:,:,i);
imagesc(Img)

subplot(1,3,2)
ImgD = depths(:,:,i);
imagesc(ImgD)

subplot(1,3,3)
ImgL = labels(:,:,i);
imagesc(ImgL)

%%
img_depth = ImgD;
xyzPoints = depth2pcl(img_depth);

%
figure(2)
plot_points(xyzPoints)

%%
% % 936 941 943 949 955 1063 
% 
% i = 1182
% load(['../regions/regions_from_labels_00' sprintf('%.4d', i) '.mat'])
% % load('../regions/regions_from_labels_000909.mat')
% imagesc(imgRegions)

%%
% mask = imgRegions>2 & imgRegions<5;
% imagesc(mask)

mask = ImgL == 83;
imagesc(mask)

stats = regionprops(mask,'all');
% stats(23)
stats

N = size(stats,1)
% imagesc(mask)
for i=1:N
    hold on
    points = stats(i).Centroid;
    plot(points(:,1), points(:,2), '*b')
    hold off
end

%%
img_depth = ImgD;
img_depth(~mask) = -1;
% imagesc(img_depth)
xyzPoints = depth2pcl(img_depth);
plot_points(xyzPoints)

%%
% pts = stats(1).BoundingBox;
% hold on
% % plot(pts(1), pts(2), '*r')
% plot(pts(1)+pts(3), pts(2)+pts(4), '*r')
% % hold off

bb = stats(2).BoundingBox;
rectangle('Position',[bb(1) bb(2) bb(3) bb(4)],'EdgeColor','green');

%% points to volumen
% xyzPoints

sz = size(img_depth);

z_max = max(img_depth(  :));
mask = img_depth ~= -1;
im = img_depth(mask);
z_min = min(im);
% sz(3) = max(sz);
sz(3) = 250;
domain = linspace(z_min, z_max, sz(3))

V = zeros(sz(1), sz(2), sz(3));


N = length(xyzPoints);
for i=1:N
    y = xyzPoints(i,1);
    x = xyzPoints(i,2);
    depth = xyzPoints(i,3);
    [~,idx] = min(abs(domain-depth));
    
    V(x,y,idx) = 1;
end


%
plot_volume(V)
axis([0 sz(1) 0 sz(2) 0 sz(3)])
% axis square





























