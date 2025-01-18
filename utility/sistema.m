function sistema(cartella,nome,classe)
    class_folders = ["A","B","C","D","E","F","G","H","I","L","M","N"];
    im=im2gray(imread(strcat(cartella,"/",nome,".png")));
    im=single(im~=0);
    numero=strsplit(nome,"-");
    numClasse=find(class_folders==classe)
    im=im.*numClasse;
    imagesc(im);
    imwrite(im, strcat(cartella,"/",numero(1),".jpg"));
end