cv2 = py.importlib.import_module("cv2");
np = py.importlib.import_module("numpy");


image = cv2.imread('images/ground_truth/A/1.jpg', cv2.IMREAD_GRAYSCALE);

if image == py.None
    error("Error: Could not load image.");
end

binary_image = cv2.threshold(image, 1, 255, cv2.THRESH_BINARY).cell{2};
moments = cv2.moments(binary_image);
hu_moments = cv2.HuMoments(moments);
matlab_hu_moments = hu_moments.double;

disp(matlab_hu_moments);