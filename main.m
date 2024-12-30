%function main
    im = im2single(imread('images/D/3.jpg'));

    % gim = im2gray(im);
    % 
    % a = gim ./ (imgaussfilt3(gim,gaussiansigma(45),'Padding','symmetric'));
    % a = a ./ max(max(a));
    % 
    % t = a - gim;
    % 
    % figure; 
    % ax1 = minsubplot(2,2,1); imshow(gim); colormap("gray");
    % ax2 = minsubplot(2,2,2); imshow(a);
    % ax3 = minsubplot(2,2,3); imagesc(t); colormap(jet); axis image; colorbar;
    % ax4 = minsubplot(2,2,4); imshow(t > 0.1);
    % linkaxes([ax1,ax2,ax3,ax4],'xy');
    % axis tight;
    % 
    % return;

    desc = seg_descriptors(im, 4800, 3);
    labels = spectral_clustering(im, desc, 2, false, false);
    labels = labels-1;

    num = sum(labels(:,1))+sum(labels(1,:))+sum(labels(:,end))+sum(labels(end,:));
    den = (2*size(im,1)+2*size(im,2));

    disp([num,den,num/den]);

    if num/den > 0.5
        labels = 1-labels;
    end

    figure_maximized; 
    ax1 = tsubplot(1,2,1); imshow(im); colormap("gray");
    ax2 = tsubplot(1,2,2); imshow(labels);
    linkaxes([ax1,ax2],'xy');
    axis tight;
%end