#include "mex.h"
#include "matrix.h"
#include <math.h>

/* Input Arguments */
#define GLCM        pts_rhs[0]

/* Output Arguments */
#define OUT_EXPECTED_X    pts_lhs[0]
#define OUT_EXPECTED_Y    pts_lhs[1]
#define OUT_VARIANCE_X    pts_lhs[2]
#define OUT_VARIANCE_Y    pts_lhs[3]
#define OUT_STD_X         pts_lhs[4]
#define OUT_STD_Y         pts_lhs[5]
#define OUT_MAX_PROB      pts_lhs[6]
#define OUT_CORRELATION   pts_lhs[7]
#define OUT_CONTRAST      pts_lhs[8]
#define OUT_UNIFORMITY    pts_lhs[9]
#define OUT_HOMOGENEITY   pts_lhs[10]
#define OUT_ENTROPY       pts_lhs[11]

/* Prototypes */
void usageError(const char *id);

void mexFunction(int num_args_lhs, mxArray *pts_lhs[], int num_rhs, const mxArray *pts_rhs[]) {
    if (num_args_lhs > 12)
        mexErrMsgIdAndTxt("MATLAB:glcmfeatures:invalidNumOutputs",
            "Invalid number of output arguments.\n  out_args: [e_x, e_y, var_x, var_y, std_x, std_y, max_prob, corr, contrast, uniformity, homogeneity, entropy].");

    size_t nDimNum;
    const mwSize *pDims;

    mwSize K;
    if (num_rhs == 1) {
        if (!mxIsDouble(GLCM) || mxIsComplex(GLCM))
            usageError("MATLAB:glcmfeatures:inputNotDouble");
        
        nDimNum = mxGetNumberOfDimensions(GLCM);
        pDims = mxGetDimensions(GLCM);
        if (nDimNum != 2)
            usageError("MATLAB:glcmfeatures:inputNotArray");
        
        K = pDims[0];
        if (K != pDims[1])
            usageError("MATLAB:glcmfeatures:inputNotSquareMatrix");
    }
    else
        usageError("MATLAB:glcmfeatures:invalidNumInputs");

    // Pointer to the GLCM matrix (array)
    mxDouble *GLCMPTR = (mxDouble *) mxGetData(GLCM);

    mwSize CDF_dims[2] = {K, 2}; // first_col: CDF_X, second_col: CDF_Y
    /* allocate memory for output image */
    mxArray* CDF = mxCreateNumericArray(2, CDF_dims, mxDOUBLE_CLASS, mxREAL);
    /* Get pointer to output image */
    mxDouble *CDFPTR = (mxDouble *) mxGetData(CDF);

    for (int i = 0; i < K * 2; i++) {
        CDFPTR[i] = 0;
    }

    mxDouble max_prob = -INFINITY;
    for (int i=0; i<K; i++) {
        for (int j=0; j<K; j++) {
            mxDouble v1 = GLCMPTR[j+i*K], v2 = GLCMPTR[i+j*K];

            CDFPTR[i] += v1;
            CDFPTR[j+K] += v2;

            mxDouble max_v = v1 > v2 ? v1 : v2;
            if (max_v > max_prob) {
                max_prob = max_v;
            }
        }
    }

    mxDouble mr = 0, mc = 0;
    for (int t=0; t<K; t++) {
        mr += (t+1) * CDFPTR[t];
        mc += (t+1) * CDFPTR[t+K];
    }

    mxDouble varr = 0, varc = 0;
    for (int t=0; t<K; t++) {
        varr += pow(t+1-mr, 2) * CDFPTR[t];
        varc += pow(t+1-mc, 2) * CDFPTR[t+K];
    }
    mxDestroyArray(CDF); // free 

    mxDouble stdr = sqrt(varr), stdc = sqrt(varc),
             correlation = 0, contrast = 0, uniformity = 0,
             homogeneity = 0, entropy = 0, inv_log2 = 1.0 / log(2.0);
    for (int i=0; i<K; i++) {
        for (int j=0; j<K; j++) {
            mxDouble diffr = i+1-mr, diffc = j+1-mc, diff_ind = (mxDouble)(i-j), p_ij = GLCMPTR[i+j*K];
            correlation += diffr * diffc * p_ij;
            contrast += diff_ind * diff_ind * p_ij;
            uniformity += p_ij * p_ij;
            homogeneity += p_ij / (1 + abs(diff_ind));
            if (p_ij > 0)
                entropy -= p_ij * log(p_ij) * inv_log2;
        }
    }

    if (stdr > 0 && stdc > 0)
        correlation /= (stdr * stdc);
    else
        correlation = 0;

    // Create the output matrices
    OUT_EXPECTED_X = mxCreateDoubleScalar(mr);
    OUT_EXPECTED_Y = mxCreateDoubleScalar(mc);
    OUT_VARIANCE_X = mxCreateDoubleScalar(varr);
    OUT_VARIANCE_Y = mxCreateDoubleScalar(varc);
    OUT_STD_X      = mxCreateDoubleScalar(stdr);
    OUT_STD_Y      = mxCreateDoubleScalar(stdc);

    OUT_MAX_PROB      = mxCreateDoubleScalar(max_prob);
    OUT_CORRELATION   = mxCreateDoubleScalar(correlation);

    OUT_CONTRAST      = mxCreateDoubleScalar(contrast);
    OUT_UNIFORMITY    = mxCreateDoubleScalar(uniformity);
    OUT_HOMOGENEITY   = mxCreateDoubleScalar(homogeneity);
    OUT_ENTROPY       = mxCreateDoubleScalar(entropy);
    return;
}

void usageError(const char *id) {
    mexErrMsgIdAndTxt(id,
        "Correct usage: glcmfeatures(glcm)\n"
        "    glcm: normalized gray-level co-matrix of type double.");
}