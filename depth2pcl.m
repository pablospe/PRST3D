function xyzPoints = depth2pcl(img_depth)
    sz = size(img_depth);
    N = sz(1)*sz(2);
    xyzPoints = zeros(N, 3);
%     xyzPoints = [];
    i = 1;
    for x=1:sz(1)
        for y=1:sz(2)
            depth = img_depth(x,y);
            if depth < 0
                continue;  % it is an invalid depth (this can be used to filter)
            end
            
%             xyzPoints = [xyzPoints; [y x depth]];
            xyzPoints(i,1) = y;
            xyzPoints(i,2) = x;
            xyzPoints(i,3) = depth;
            i = i+1;
        end
    end
    
%%
%     % ToDo: remove zeros
% i-1 < N
xyzPoints = xyzPoints(1:(i-1),:);
%     for i=1:N
% %         if (xyzPoints(i,1) == 0 & xyzPoints(i,2) == 0 & xyzPoints(i,3) == 0)
% %         xyzPoints(i,:)
% %         if (xyzPoints(i,:)
% %             
% %         end
%     end
end
