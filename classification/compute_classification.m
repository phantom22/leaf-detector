function data = compute_classification(im_foglia,mask_foglia)
    
    mask_sfondo=1-mask_foglia;
    dw=bwlabel(mask_sfondo);
    stats = regionprops(mask_sfondo, 'Area');
    [~, largestRegionIdx] = max([stats.Area]);
    mask_foglia=single(1-uint8(dw==largestRegionIdx));

    im_foglia=im_foglia.*mask_foglia;
    grayImg=im2gray(im_foglia);
    data=zeros(1,14,"double");
    stats = regionprops(mask_foglia, 'Area', 'Perimeter', 'Eccentricity', "MajorAxisLength","MinorAxisLength", 'Solidity');

    area = stats.Area;
    perimeter = stats.Perimeter;
    eccentricity = stats.Eccentricity;
    solidity = stats.Solidity;
    boundary = bwboundaries(mask_foglia);
    boundaryCoords = boundary{1};
    curvature = calculateCurvature(boundaryCoords);
    M20 = 0;
    [m,n]=size(mask_foglia);
    % Calcola il momento di ordine 2 (M20)
    for x = 1:n
        for y = 1:m
            if mask_foglia(y, x) == 1  % Se il pixel è "1" (oggetto)
                M20 = M20 + (x^2) * mask_foglia(y, x);
            end
        end
    end
    data(1)=stats.MajorAxisLength/stats.MinorAxisLength;
    data(2)=eccentricity;
    data(3)=solidity;
    data(4)= mean(abs(curvature));
    data(5)=M20;
    law=compute_laws_features(grayImg);
    data(6:14)=mean(mean(abs(law(:,:,1:9))));

end
