function [gabor_filters,gabor_sigmas] = prepare_gabor_filters
    K = 3;
    orientation = 0:45:315;
    omega = 4/sqrt(2);
    wavelength = [1 2 4] * omega;

    gabor_filters = gabor(wavelength, orientation);
    sigmas = wavelength * K / 2;
    gabor_sigmas = [sigmas,sigmas,sigmas,sigmas,sigmas,sigmas,sigmas,sigmas];
end