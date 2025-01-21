function visualizzaClassi(classificato)
    class_folders = ["A","B","C","D","E","F","G","H","I","L","M","N"];
    [labels, numRegions] = bwlabel(classificato~=0);
    for i=1:numRegions
        maskF=uint8(labels==i);
        centroide=regionprops(maskF,"Centroid").Centroid;
        classe=max(max(maskF.*classificato));
        letteraClasse=class_folders(classe);
        hold on;
        text(centroide(1), centroide(2),letteraClasse, 'Color', hex2rgb('#FFFF99'), 'FontSize', 8, 'FontWeight', 'bold');
        hold off;
    end
end