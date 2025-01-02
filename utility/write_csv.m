function  write_csv(matrix,append)
    if append
        fid = fopen(filename, 'a');
    else
        fid = fopen(filename, 'w');
    end
    [nRows, ~] = size(matrix);
    for i = 1:nRows
        fprintf(fid, '%f', matrix(i, 1)); % Scrivi il primo elemento
        fprintf(fid, ',%f', matrix(i, 2:end)); % Scrivi i restanti elementi separati da virgola
        fprintf(fid, '\n'); % Vai a capo
    end
    fclose(fid);
end

