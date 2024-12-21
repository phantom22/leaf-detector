function out=fondi_maschere(label,labelFinali)
    [m,n]=size(label);
    out=zeros(m,n,"uint8");
    for i=1:max(max(label))
        out=out+labelFinali(i)*uint8(label==i);
    end
end