import cv2
import numpy as np

# Load a black-and-white image (assume it's already binary or grayscale)
image = cv2.imread('1.jpg', cv2.IMREAD_GRAYSCALE)

# Check if the image was loaded successfully
if image is None:
    print("Error: Could not load image.")
    exit()

# Threshold the image to ensure it's binary (if it's not already)
_, binary_image = cv2.threshold(image, 1, 255, cv2.THRESH_BINARY)

# Calculate moments
moments = cv2.moments(binary_image)

# Calculate Hu Moments
hu_moments = cv2.HuMoments(moments)

# Display the raw moments to the console
print("Raw Moments:")
for key, value in moments.items():
    print(f"{key}: {value}")

# Display the Hu Moments to the console
print("\nHu Moments:")
for i, hu_moment in enumerate(hu_moments):
    print(f"Hu Moment {i + 1}: {hu_moment[0]}")