function visualize_pixel_descriptors(im_path)
    im = imresizetoarea(im2single(imread(im_path)), 300*400);
    im = whitebalance(im);

    tic;
    im_C = local_segment(im);
    toc;

    num_features = size(im_C,3);
    
    [m,n] = calcola_ingombro_minimo_subplot(num_features);

    figure_maximized;
    for i=1:num_features
        tsubplot(m,n,i);
        imagesc(im_C(:,:,i));
        axis image;
        axis off;
        colorbar;
    end
end

function d = local_segment(im)
    if ~isa(im,'single')
        im = im2single(im);
    end

    load('segmentation/gabordata.mat','gabor_filters','gabor_sigmas');

    width = size(im,2);

    d = zeros(size(im,1),width,8,'single');

    hsvim = rgb2hsv(im);
    %gim = imgaussfilt(rgb2gray(im), 1.5);
    v_gauss = imgaussfilt(hsvim(:,:,3), 1.5);
    ycbcrim = rgb2ycbcr(im);
    labim = rgb2lab(im);
    [sobel,~] = mysobel(v_gauss, 1/2);
    lap = mylaplacian(v_gauss);

    d(:,:,1) = min(max(hsvim(:,:,2), 0), 1); % s
    d(:,:,2) = ycbcrim(:,:,2); % cb
    d(:,:,3) = labim(:,:,2); % a
    d(:,:,4) = labim(:,:,3); % b
    d(:,:,5) = sobel + lap; % similar to L

    gabormag = imgaborfilt(v_gauss, gabor_filters);
    gabormag = arrayfun(@(i) imgaussfilt(gabormag(:,:,i), gabor_sigmas(i)), 1:24, 'UniformOutput', false);
    gabormag = cat(3, gabormag{:});

    d(:,:,6) = gabormag(:,:,1)+gabormag(:,:,4)+gabormag(:,:,7)+gabormag(:,:,10)+gabormag(:,:,13)+gabormag(:,:,16)+gabormag(:,:,19)+gabormag(:,:,22);
    d(:,:,7) = gabormag(:,:,2)+gabormag(:,:,5)+gabormag(:,:,8)+gabormag(:,:,11)+gabormag(:,:,14)+gabormag(:,:,17)+gabormag(:,:,20)+gabormag(:,:,23);
    d(:,:,8) = gabormag(:,:,3)+gabormag(:,:,6)+gabormag(:,:,9)+gabormag(:,:,12)+gabormag(:,:,15)+gabormag(:,:,18)+gabormag(:,:,21)+gabormag(:,:,24);

    % gabormag = imgaborfilt(gim, gabor_filters);
    % gabormag = arrayfun(@(i) imgaussfilt(gabormag(:,:,i), gabor_sigmas(i)), 1:32, 'UniformOutput', false);
    % gabormag = cat(3, gabormag{:});
    % 
    % d(:,:,6) = gabormag(:,:,1)+gabormag(:,:,5)+gabormag(:,:,9)+gabormag(:,:,13)+gabormag(:,:,17)+gabormag(:,:,21)+gabormag(:,:,25)+gabormag(:,:,29);
    % d(:,:,7) = gabormag(:,:,2)+gabormag(:,:,6)+gabormag(:,:,10)+gabormag(:,:,14)+gabormag(:,:,18)+gabormag(:,:,22)+gabormag(:,:,26)+gabormag(:,:,30);
    % d(:,:,8) = gabormag(:,:,3)+gabormag(:,:,7)+gabormag(:,:,11)+gabormag(:,:,15)+gabormag(:,:,19)+gabormag(:,:,23)+gabormag(:,:,27)+gabormag(:,:,31);
    % d(:,:,9) = gabormag(:,:,4)+gabormag(:,:,8)+gabormag(:,:,12)+gabormag(:,:,16)+gabormag(:,:,20)+gabormag(:,:,24)+gabormag(:,:,28)+gabormag(:,:,32);
end