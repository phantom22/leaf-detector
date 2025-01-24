function [strong,weak,canny] = extract_edges(masked_gray)
    fim = imgaussfilt(masked_gray, gaussiansigma(3));
    L = mylaplacian(fim);
    t = graythresh(L);
    strong = normalize_edges((L >= t) .* L);
    weak = normalize_edges((L < t) .* L);
    canny = edge(L,'canny',[t/2, 1.2*t/2]);
end

function N = normalize_edges(E)
    m = min(min(E));
    M = max(max(E));
    N = (E - m) ./ (M - m);
end