#include "mex.h"
#include "matrix.h"
#include <math.h>

/* Input Arguments */
#define BINS        pts_rhs[0]

/* Output Arguments */
#define OUT_WEIGHTEDMEAN  pts_lhs[0]
#define OUT_STATSTD       pts_lhs[1]
#define OUT_FIRST         pts_lhs[2]
#define OUT_SECOND        pts_lhs[3]
#define OUT_THIRD         pts_lhs[4]
#define OUT_RELATIVE      pts_lhs[5]
#define OUT_UNIFORMITY    pts_lhs[6]
#define OUT_ENTROPY       pts_lhs[7]

/* Prototypes */
void usageError(const char *id);

void mexFunction(int num_args_lhs, mxArray *pts_lhs[], int num_rhs, const mxArray *pts_rhs[]) {
    if (num_args_lhs > 8)
        mexErrMsgIdAndTxt("MATLAB:binfeatures:invalidNumOutputs",
            "Invalid number of output arguments.\n  out_args: [weighted_mean, standard_deviation, first_moment, second_moment, third_moment, relative_variance, uniformity, entropy].");

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
        
        mwSize n = pDims[0], weighted_mean = pDims[1];
        if (weighted_mean != 1 && n != 1)
            usageError("MATLAB:binfeatures:inputNotMatrix");
        N = (weighted_mean > n) ? weighted_mean : n;
    }
    else
        usageError("MATLAB:binfeatures:invalidNumInputs");

    // Pointer to the BINS matrix (array)
    mxDouble *BINSPTR = (mxDouble *) mxGetData(BINS);

    // sum = 1.0 because the bins are assumed to be a distribution function.
    mxDouble uniformity = 0.0, weighted_mean = 0;
    for (int zi=0; zi<N; zi++) {
        mxDouble p = BINSPTR[zi];
        uniformity += p * p;
        weighted_mean += zi * p;
    }

    mxDouble statistical_mean = 1.0 / N,
             statistical_var = (uniformity - statistical_mean) / (N-1),
             statistical_std = sqrt(statistical_var),
             log2 = 1 / log(2.0);

    mxDouble first = 0, second = 0, third = 0, entropy = 0;
    for (int zi=0; zi<N; zi++) {
        mxDouble p = BINSPTR[zi],
                 diff = zi - weighted_mean;
        
        first += diff * p;
        second += pow(diff,2) * p;
        third += pow(diff,3) * p;
        if (p > 0)
            entropy -= p* log(p) * log2; 
    }

    mxDouble relative = 1 - 1 / (1 + statistical_var);

    // Create the output matrices
    OUT_WEIGHTEDMEAN = mxCreateDoubleScalar(weighted_mean);
    OUT_STATSTD = mxCreateDoubleScalar(statistical_std);
    OUT_FIRST = mxCreateDoubleScalar(first);
    OUT_SECOND = mxCreateDoubleScalar(second);
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