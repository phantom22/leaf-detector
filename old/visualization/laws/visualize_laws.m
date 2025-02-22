function visualize_laws
    close all;

    im = imread('images/A/1.jpg');
    t = medfilt3(im,[5 5 1]);

    %noshadowim = im ./ imgaussfilt(rgb2gray(im),gaussiansigma(50),"Padding","symmetric");
    %ns_min = min(min(min(noshadowim)));
    %ns_max = max(max(max(noshadowim)));
    %noshadowim = medfilt3((noshadowim - ns_min)  / (ns_max - ns_min), [9 9 1], "symmetric");
    %t = imgaussfilt3(noshadowim, gaussiansigma(3));

    [desc,LL,LE,LS,LR,LW,EL,EE,ES,ER,EW,SL,SE,SS,SR,SW,RL,RE,RS,RR,RW,WL,WE,WS,WR,WW] = test_extract_law_descriptors(t, 4800);
    masks = {LL,LE,LS,LR,LW,EL,EE,ES,ER,EW,SL,SE,SS,SR,SW,RL,RE,RS,RR,RW,WL,WE,WS,WR,WW};
    descriptors = desc.descriptors;
    SP = desc.superpixels;

    descriptor_labels = {
        'R channel';'G channel';'B channel';
        'LL';'LE';'LS';'LR';'LW';
        'EL';'EE';'ES';'ER';'EW';
        'SL';'SE';'SS';'SR';'SW';
        'RL';'RE';'RS';'RR';'RW';
        'WL';'WE';'WS';'WR';'WW';'Saturation';
    };

    num_descriptors = size(descriptors, 2);

    figure_maximized;
    for d=1:3
        vals = descriptors(:,d);
        tsubplot(6, 4, d);
        timagesc(vals(SP), descriptor_labels{d});
    end

    vals = descriptors(:,29);
    tsubplot(6, 4, 4);
    timagesc(vals(SP), descriptor_labels{29});

    for d=4:num_descriptors-1
        vals = descriptors(:,d);
        tsubplot(6, 5, d+2);
        timagesc(vals(SP), descriptor_labels{d});
    end

    for g=1:5
        figure_maximized;
        
        i1 = 4+(g-1)*5;
        i2 = i1+1;
        i3 = i1+2;
        i4 = i1+3;
        i5 = i1+4;
        
        v1 = descriptors(:,i1);
        v2 = descriptors(:,i2);
        v3 = descriptors(:,i3);
        v4 = descriptors(:,i4);
        v5 = descriptors(:,i5);

        tsubplot(3,2,1);
        timagesc(v1(SP), descriptor_labels{i1});

        tsubplot(3,2,2);
        timagesc(v2(SP), descriptor_labels{i2});

        tsubplot(3,1,2);
        timagesc(v3(SP), descriptor_labels{i3});

        tsubplot(3,2,5);
        timagesc(v4(SP), descriptor_labels{i4});

        tsubplot(3,2,6);
        timagesc(v5(SP), descriptor_labels{i5});
    end

    for g=1:5
        set(figure, 'WindowState', 'maximized');
        
        i1 = 1+(g-1)*5;
        i2 = i1+1;
        i3 = i1+2;
        i4 = i1+3;
        i5 = i1+4;

        tsubplot(3,2,1);
        timagesc(masks{i1},descriptor_labels{i1+3});

        tsubplot(3,2,2);
        timagesc(masks{i2},descriptor_labels{i2+3});

        tsubplot(3,1,2);
        timagesc(masks{i3},descriptor_labels{i3+3});

        tsubplot(3,2,5);
        timagesc(masks{i4},descriptor_labels{i4+3});

        tsubplot(3,2,6);
        timagesc(masks{i5},descriptor_labels{i5+3});
    end
end