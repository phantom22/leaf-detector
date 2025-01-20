A = imread("images/A/1.jpg");
B = imread("images/M/1.jpg");

A_HSV = rgb2hsv(A);
A_GRAY = rgb2gray(A);
B_HSV = rgb2hsv(B);
B_GRAY = rgb2gray(B);

[A_HSV_s,A_HSV_d] = mysobel(A_HSV(:,:,3),0.5);
[A_GRAY_s,A_GRAY_d] = mysobel(im2single(A_GRAY),0.5);
[B_HSV_s,B_HSV_d] = mysobel(B_HSV(:,:,3),0.5);
[B_GRAY_s,B_GRAY_d] = mysobel(im2single(B_GRAY),0.5);

figure_maximized; 
A1 = tsubplot(2,2,1); timshow(A_HSV_s); 
A2 = tsubplot(2,2,2); timshow(A_GRAY_s); 
A3 = tsubplot(2,2,3); timshow(B_HSV_s); 
A4 = tsubplot(2,2,4); timshow(B_GRAY_s);

linkaxes([A1,A2,A3,A4], 'xy');
axis tight;

A_HSV_thresh = graythresh(A_HSV_s);
A_GRAY_thresh = graythresh(A_GRAY_s);
B_HSV_thresh = graythresh(B_HSV_s);
B_GRAY_thresh = graythresh(B_GRAY_s);

figure_maximized; 
B1 = tsubplot(2,2,1); timshow((A_HSV_s > A_HSV_thresh) .* A_HSV_s); 
B2 = tsubplot(2,2,2); timshow((A_GRAY_s > A_GRAY_thresh) .* A_GRAY_s); 
B3 = tsubplot(2,2,3); timshow((B_HSV_s > B_HSV_thresh) .* B_HSV_s); 
B4 = tsubplot(2,2,4); timshow((B_GRAY_s > B_GRAY_thresh) .* B_GRAY_s); 

linkaxes([B1,B2,B3,B4], 'xy');
axis tight;

figure_maximized; 
C1 = tsubplot(2,2,1); timagesc((A_HSV_s > A_HSV_thresh) .* A_HSV_d); 
C2 = tsubplot(2,2,2); timagesc((A_GRAY_s > A_GRAY_thresh) .* A_GRAY_d); 
C3 = tsubplot(2,2,3); timagesc((B_HSV_s > B_HSV_thresh) .* B_HSV_d); 
C4 = tsubplot(2,2,4); timagesc((B_GRAY_s > B_GRAY_thresh) .* B_GRAY_d); 

linkaxes([C1,C2,C3,C4], 'xy');
axis tight;