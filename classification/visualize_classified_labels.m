function visualize_classified_labels(classificato)
    class_folders = ["A","B","C","D","E","F","G","H","I","L","M","N","Unknown"];
    mappingNome = ["Lauroceraso","Edera","Laurotino","Rubus","Ulivo","Acero riccio","Bambù","Olmo","Agrifoglio","Rovere","Acero campestre","Pungitopo","Unknown"];
    
    [labels, numRegions] = bwlabel(classificato~=0);
    for i=1:numRegions
        maskF = uint8(labels==i);
        c = regionprops(maskF,"Centroid").Centroid;
        classe = max(max(maskF.*classificato));
        letteraClasse =mappingNome( classe);
        hold on;
        text(c(1)-strlength(letteraClasse)*7, c(2), letteraClasse, 'Color', hex2rgb('#FFFF99'), 'FontSize', 8, 'FontWeight', 'bold');
        hold off;
    end
end