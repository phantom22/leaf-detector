function al = align_second_signal(sig1, sig2)
    [c, lags] = xcorr(sig1, sig2);
    [~, maxIndex] = max(c);
    lag = lags(maxIndex);
    al = circshift(sig2, -lag);
end