function out=extract_fusion_descriptors(max_label,labels,im_con_canali_selezionati)
    [m,n,c]=size(im_con_canali_selezionati);
    out=zeros(max_label,c);
    for label=1:max_label
        masks=labels==label;
        out(label,1:c)=sum(sum(masks.*im_con_canali_selezionati))/nnz(masks);
    end
end