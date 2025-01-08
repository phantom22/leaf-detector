function data = compute_classification(im_foglia,mask_foglia)
    data=zeros(1,4,"double");
    prop= regionprops(mask_foglia,"Circularity","Eccentricity","MajorAxisLength","MinorAxisLength");%,"WeightedCentroid");
    data(1)=prop.Circularity;
    data(2)=prop.Eccentricity;
    data(3)=prop.MajorAxisLength\prop.MinorAxisLength;
    %data(4)=prop.WeightedCentroid;
end

