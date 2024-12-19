function gaborFeatures = createGaborFeatures(im)

if size(im,3) == 3
    im = rgb2lab(im);
end

im = im2single(im);

imageSize = size(im);
numRows = imageSize(1);
numCols = imageSize(2);

wavelengthMin = 4/sqrt(2);
wavelengthMax = hypot(numRows,numCols);
n = floor(log2(wavelengthMax/wavelengthMin));
wavelength = 2.^(0:(n-2)) * wavelengthMin;

deltaTheta = 45;
orientation = 0:deltaTheta:(180-deltaTheta);

g = gabor(wavelength,orientation);
gabormag = imgaborfilt(im(:,:,1),g);

for i = 1:length(g)
    sigma = 0.5*g(i).Wavelength;
    K = 3;
    gabormag(:,:,i) = imgaussfilt(gabormag(:,:,i),K*sigma);
    t = figure; 
    t.WindowState = "maximized";
    imagesc(gabormag(:,:,i));
end



% % Increases liklihood that neighboring pixels/subregions are segmented together
% X = 1:numCols;
% Y = 1:numRows;
% [X,Y] = meshgrid(X,Y);
% featureSet = cat(3,gabormag,X);
% featureSet = cat(3,featureSet,Y);
% featureSet = reshape(featureSet,numRows*numCols,[]);
% 
% % Normalize feature set
% featureSet = featureSet - mean(featureSet);
% featureSet = featureSet ./ std(featureSet);
% 
% gaborFeatures = reshape(featureSet,[numRows,numCols,size(featureSet,2)]);
% 
% % Add color/intensity into feature set
% gaborFeatures = cat(3,gaborFeatures,im);

end

im = imread("4.jpg");

createGaborFeatures(im);