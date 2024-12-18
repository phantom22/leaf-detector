#include "mex.h"
#include "matrix.h"
#include <math.h>

/* Input Arguments */
#define BINS        pts_rhs[0]

/* Output Arguments */
#define OUT_EXPECTED      pts_lhs[0]
#define OUT_VARIANCE      pts_lhs[1]
#define OUT_STD           pts_lhs[2]
#define OUT_FIRST         pts_lhs[3]
#define OUT_THIRD         pts_lhs[4]
#define OUT_RELATIVE      pts_lhs[5]
#define OUT_UNIFORMITY    pts_lhs[6]
#define OUT_ENTROPY       pts_lhs[7]

/* Prototypes */
void usageError(const char *id);

void mexFunction(int num_args_lhs, mxArray *pts_lhs[], int num_rhs, const mxArray *pts_rhs[]) {
    if (num_args_lhs > 8)
        mexErrMsgIdAndTxt("MATLAB:binfeatures:invalidNumOutputs",
            "Invalid number of output arguments.\n  out_args: [expected_value, variance, standard_deviation, first_moment, third_moment, relative_variance, uniformity, entropy].");

    size_t nDimNum;
    const mwSize *pDims;
    mwSize N;
    if (num_rhs == 1) {
        if (!mxIsDouble(BINS) || mxIsComplex(BINS))
            usageError("MATLAB:binfeatures:inputNotDouble");
        
        nDimNum = mxGetNumberOfDimensions(BINS);
        pDims = mxGetDimensions(BINS);
        if (nDimNum != 2)
            usageError("MATLAB:binfeatures:inputNotArray");
        
        mwSize n = pDims[0], m = pDims[1];
        if (m != 1 && n != 1)
            usageError("MATLAB:binfeatures:inputNotMatrix");
        N = (m > n) ? m : n;
    }
    else
        usageError("MATLAB:binfeatures:invalidNumInputs");

    // Pointer to the GLCM matrix (array)
    mxDouble *BINSPTR = (mxDouble *) mxGetData(BINS);

    // sum = 1.0 because the bins are assumed to be a distribution function.
    mxDouble uniformity = 0.0, expected_value = 0;
    for (int zi=0; zi<N; zi++) {
        mxDouble p_zi = BINSPTR[zi];
        uniformity += p_zi * p_zi;
        expected_value += zi * p_zi;
    }

    mxDouble first = 0, second = 0, third = 0, 
             entropy = 0, inv_log2 = 1 / log(2.0);
    for (int zi=0; zi<N; zi++) {
        mxDouble p_zi = BINSPTR[zi],
                 diff = zi - expected_value;
        
        first += diff * p_zi;
        second += pow(diff,2) * p_zi;
        third += pow(diff,3) * p_zi;
        if (p_zi > 0) // this prevents NaN's from log(non_positive_value)
            entropy -= p_zi * log(p_zi) * inv_log2; 
    }

    mxDouble statistical_std = sqrt(second),
             relative = 1 - 1 / (1 + second);

    // Create the output matrices
    OUT_EXPECTED = mxCreateDoubleScalar(expected_value);
    OUT_VARIANCE = mxCreateDoubleScalar(second);
    OUT_STD = mxCreateDoubleScalar(statistical_std);
    OUT_FIRST = mxCreateDoubleScalar(first);
    OUT_THIRD = mxCreateDoubleScalar(third);
    OUT_RELATIVE = mxCreateDoubleScalar(relative);
    OUT_UNIFORMITY = mxCreateDoubleScalar(uniformity);
    OUT_ENTROPY = mxCreateDoubleScalar(entropy);
    return;
}

void usageError(const char *id) {
    mexErrMsgIdAndTxt(id,
        "Correct usage: binfeatures(bins)\n"
        "    bins: array of probabilities of type double.");
}