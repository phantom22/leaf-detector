im = "A\10.jpg";
img = im2single(imread("images/" + im));
gt = im2single(imread("images/ground_truth/" + im));

HSV = rgb2hsv(img);

[strong,weak,canny] = extract_edges(HSV(:,:,3) .* gt);

figure_maximized;
tsubplot(1,3,1); timagesc(strong);
tsubplot(1,3,2); timagesc(weak);
tsubplot(1,3,3); timagesc(canny);