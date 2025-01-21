% Read an example image
img = imread('images/M/15.jpg');  % Replace with your image file

se = strel('disk', 5);

% Convert the image to grayscale (if needed) and threshold it to create a binary image
grayImg = rgb2gray(img);

tmp = imread('images/ground_truth/M/15.jpg') > 1;
tmp = bwopen(bwclose(tmp,se),se);

% Compute region properties for the binary image
stats = regionprops(tmp, 'ConvexHull');  % Get the convex hull of the regions

% Display the original image
imshow(img);
hold on;

% Overlay the convex hull on the image using the 'ConvexHull' property
for k = 1:length(stats)
    % Get the convex hull coordinates
    convexHull = stats(k).ConvexHull;
    
    % Create the convex hull boundary (closed polygon)
    fill(convexHull(:,1), convexHull(:,2), 'r', 'FaceAlpha', 0.3);  % Red, with transparency
end

hold off;
title('Image with Convex Hull Boundaries');