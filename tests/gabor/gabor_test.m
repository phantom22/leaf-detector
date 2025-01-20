function createGaborFeatures(im)

    if size(im,3) == 3
        im = rgb2lab(im);
    end
    
    im = im2single(im);
    
    % imageSize = size(im);
    % numRows = imageSize(1);
    % numCols = imageSize(2);
    % 
    % wavelengthMin = 4/sqrt(2);
    % wavelengthMax = hypot(numRows,numCols);
    % n = floor(log2(wavelengthMax/wavelengthMin));
    % wavelength = 2.^(0:(n-2)) * wavelengthMin;
    % 
    % deltaTheta = 45;
    % orientation = 0:deltaTheta:(180-deltaTheta);
    % 
    % g = gabor(wavelength,orientation);

    load('segmentation/gabordata.mat','gabor_filters', 'gabor_sigmas');
    
    gabormag = imgaborfilt(im(:,:,3), gabor_filters);

    gcount = length(gabor_filters);

    [m,n] = calcola_ingombro_minimo_subplot(gcount);

    figure_maximized;
    for i = 1:gcount
        gabormag(:,:,i) = imgaussfilt(gabormag(:,:,i), gabor_sigmas(i));
        tsubplot(n,m,i);
        timagesc(gabormag(:,:,i), num2str(i));
    end

end

close all;

im = imread("images/Z/5.jpg");
im = imresize(im, [300 400]);

disp(size(im));

createGaborFeatures(im);

figure_maximized;
timshow(im);