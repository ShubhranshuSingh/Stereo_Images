%%
clear
clc
%% 1 Read Images
I1 = imread('im0.png'); % First Image
I2 = imread('im1.png'); % Second Image
I1 = imresize(I1, [NaN 300]);
I2 = imresize(I2, [NaN 300]);

I1_g = single(rgb2gray(I1));
I2_g = single(rgb2gray(I2));

[m,n,~] = size(I1);
%% Calculate matching descriptors(SIFT)
[f1, d1] = vl_sift(I1_g);
[f2, d2] = vl_sift(I2_g);

match = vl_ubcmatch(d1,d2);

matchedPoints1 = f1(1:2,match(1,:))';
matchedPoints2 = f2(1:2,match(2,:))';


showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2,'montage','PlotOptions',{'ro','go','y--'});
%% 2 Estimate Fundamental Matrix
[f, inliers] = estimateFundamentalMatrix(matchedPoints1,matchedPoints2,'Method','RANSAC','NumTrials',2000,'DistanceThreshold',5);

% Epipolar line is shown
% 50,50 point is taken
p = [50;50;1];
l = f*p;
x = 1:n;
y = (-l(3)/l(2))-((l(1)/l(2))*x);

figure();
imshow(I1);
hold on;
plot(p(1),p(2),'b*');
title('Point in first image');

figure();
imshow(I2);
hold on;
plot(x,y);
title('Eplipolar Line in second image');

%% Dense SIFT for descriptor at each point(except some boundary pixels)
bin_size = 8;

% Locs stores x,y coordinates of descriptors
[~, des_1] = vl_dsift(I1_g,'size',bin_size);
[locs, des_2] = vl_dsift(I2_g,'size',bin_size);

%% 3,4 Find corresponding points

% Some boundary pixels do not have descriptors and hence are not taken
start = 1+(3/2)*bin_size;
stop_x  = n-(3/2)*bin_size;
stop_y  = m-(3/2)*bin_size;

x = start:stop_x;% x coordinates of point lying on the line(All columns)

matches = zeros(size(locs,2),4); % Matrix that stores matched points 
matches(:,1:2) = locs'; % Points of first image

for i=1:size(locs,2)
    point = [locs(:,i);1]; % Point of first image
    l2 = f*point; % Epipolar line
    y = round((-l2(3)/l2(2))-((l2(1)/l2(2))*x)); % y coordinates of point lying on the line
    des1 = des_1(:,i); % Descriptor of current point
    dist =  inf;
    for k = 1:size(x,2)
        if y(k)>=start && y(k)<=stop_y
            idx = (x(k)-start)*(stop_y-start+1)+y(k)-start+1;
            des2 = des_2(:,idx); % Descriptor of point in second image
            temp = norm(double(des2)-double(des1)); % Distance between descriptors
            if(temp < dist) % If distance minimum, point is stored
                matches(i,3:4) = [x(k), y(k)];
                dist = temp;
            end
        end
    end    
end

%% 5 Reconstruct Image 1 from 2

% Output image
out_image = zeros(m,n,3);

for i=1:size(matches,1)
    x_1 = matches(i,1);
    y_1 = matches(i,2);
    x_2 = matches(i,3); 
    y_2 = matches(i,4);
    if(x_2 ~= 0 && y_2 ~=0)
        % x_2,y_2 point in image 2 map to x_1,y_1 point in image 1
        % image 1 is thus reconstructed
        out_image(y_1,x_1,:) = I2(y_2,x_2,:);
    end
end

figure()
imshow(uint8(out_image));