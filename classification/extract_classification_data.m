function data = extract_classification_data(im_foglia,mask_foglia)
    %prop= regionprops(mask_foglia,"Circularity","Eccentricity","MajorAxisLength","MinorAxisLength");%,"WeightedCentroid");
    %data(1)=prop.Circularity;
    %data(2)=prop.Eccentricity;
    %data(3)=prop.MajorAxisLength;
    %data(4)=prop.MinorAxisLength;

    mask_sfondo=1-mask_foglia;
    dw=bwlabel(mask_sfondo);
    stats = regionprops(mask_sfondo, 'Area');
    [~, largestRegionIdx] = max([stats.Area]);
    mask_foglia=single(1-uint8(dw==largestRegionIdx));

    data = single(signature_interp(mask_foglia, 64));
    data(end+1,:) = sum(sum(mylaplacian(im2gray(im_foglia) .* mask_foglia))) / nnz(mask_foglia);
    momenti=calcolaMomenti(mask_foglia);
    data(end+1,:) =(momenti(1,:)-momenti(2,:));
end

