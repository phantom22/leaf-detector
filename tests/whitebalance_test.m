function whitebalance_test(path)
    x = im2single(imread(path));
    figure_maximized; 
    ax1 = tsubplot(2,2,1); timshow(x, "original image");
    ax2 = tsubplot(2,2,2); timshow(whitebalance(x), "whitebalance on rgb, gw");
    ax3 = tsubplot(2,2,3); timshow(whitebalance3(x), "whitebalance on lin, gw + intensity");
    ax4 = tsubplot(2,2,4); timshow(whitebalance3p(x), "whitebalance on lin, gw");
    linkaxes([ax1, ax2, ax3, ax4], 'xy');
    axis tight;
end