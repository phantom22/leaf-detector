function HU = py_hu_moments(BW)
    HU = py.cv2.HuMoments(py.cv2.moments(py.numpy.array(BW, pyargs('dtype', 'uint8')))).double;
end