#include "mex.h"
#include "matrix.h"
#include <math.h>

/* Input Arguments */
#define	IM       pts_rhs[0]
#define	NUM_BINS pts_rhs[1]
#define	MASK     pts_rhs[2]

/* Output Arguments */
#define OUT_UNIFORMITY    pts_lhs[0]
#define OUT_ENTROPY       pts_lhs[1]

/* Prototypes */
void computeMaskBins(mxDouble *OUTPTR, int *out_counter, mxSingle *IMPTR, mxLogical *MASKPTR, mwSize m, mwSize n, int nl);
void computeBins(mxDouble *OUTPTR, int *out_counter, mxSingle *IMPTR, mwSize m, mwSize n, int nl);
void usageError(const char *id);
void invalidEntriesError();

void mexFunction(int num_args_lhs, mxArray *pts_lhs[], int num_rhs, const mxArray *pts_rhs[]) {
    if (num_args_lhs > 2)
        mexErrMsgIdAndTxt("MATLAB:stripped_binfeatures:invalidNumOutputs",
			"Invalid number of output arguments.\n  out_args: [uniformity, entropy].");

    size_t nDimNum;
    const mwSize *pDims;
    mwSize m, n;
    int N = 8;
    mxLogical *MASKPTR;
    int with_mask = 0;
    if (num_rhs > 0 && num_rhs < 4) {
        if (!mxIsSingle(IM) || mxIsComplex(IM))
            usageError("MATLAB:stripped_binfeatures:firstInputNotSingle");
        nDimNum = mxGetNumberOfDimensions(IM);
	    pDims = mxGetDimensions(IM);
        if (nDimNum != 2)
		    usageError("MATLAB:stripped_binfeatures:firstInputNot2DArray");
        m = pDims[0];
        n = pDims[1];
        if (num_rhs >= 2) {
            if (!mxIsDouble(NUM_BINS) || !mxIsScalar(NUM_BINS)) 
                usageError("MATLAB:stripped_binfeatures:secondInputNotDouble");
            N = (int) mxGetScalar(NUM_BINS);
            if (N < 2)
                usageError("MATLAB:stripped_binfeatures:secondInputLessThanTwo");
        }
        if (num_rhs == 3) {
            if (!mxIsLogical(MASK))
                usageError("MATLAB:stripped_binfeatures:thirdInputNotLogical");
            else if (m != mxGetM(MASK) || n != mxGetN(MASK))
                usageError("MATLAB:stripped_binfeatures:thirdInputInvalidDims");
            with_mask = 1;
            MASKPTR = (mxLogical *) mxGetData(MASK);
        }
    }
    else
        usageError("MATLAB:stripped_binfeatures:invalidNumInputs");
    
    /* Get pointer to input image */
    mxSingle *IMPTR = (mxSingle *) mxGetData(IM);

    mwSize outDims[2] = {N, 1};
    /* allocate memory for output image */
    mxArray *BINS = mxCreateNumericArray(2, outDims, mxDOUBLE_CLASS, mxREAL);
    /* Get pointer to output image */
    mxDouble *BINSPTR = (mxDouble *) mxGetData(BINS);
    
    int occurrence_count = 0;

    if (with_mask)
        computeMaskBins(BINSPTR, &occurrence_count, IMPTR, MASKPTR, m, n, N);
    else
        computeBins(BINSPTR, &occurrence_count, IMPTR, m, n, N);

    mxDouble uniformity = 0.0, entropy = 0, inv_log2 = 1 / log(2.0);
    for (int zi=0; zi<N; zi++) {
        // normalize the bins to a probability distribution
        mxDouble p_zi = BINSPTR[zi] / occurrence_count;
        uniformity += p_zi * p_zi;
        if (p_zi > 0) // this prevents NaN's from log(non_positive_value)
            entropy -= p_zi * log(p_zi) * inv_log2; 
    }

    mxDestroyArray(BINS);

    OUT_UNIFORMITY = mxCreateDoubleScalar(uniformity);
    OUT_ENTROPY = mxCreateDoubleScalar(entropy);
    return;
}

void computeMaskBins(mxDouble *OUTPTR, int *out_counter, mxSingle *IMPTR, mxLogical *MASKPTR, mwSize m, mwSize n, int nl) {
    int counter  = 0, L = n*m;

    for (int i=0; i<L; i++) {
        if (!MASKPTR[i])
            continue;

        mxSingle v = IMPTR[i];
        if (v < 0.0 || v > 1.0)
            invalidEntriesError();

        OUTPTR[v == 1.0 ? nl - 1 : (int) floor(v * nl)]++;
        counter++;
    }
    *out_counter = counter;
}

void computeBins(mxDouble *OUTPTR, int *out_counter, mxSingle *IMPTR, mwSize m, mwSize n, int nl) {
    int counter = 0, L = n*m;
    
    for (int i=0; i<L; i++) {
        mxSingle v = IMPTR[i];
        if (v < 0.0 || v > 1.0)
            invalidEntriesError();

        OUTPTR[v == 1.0 ? nl - 1 : (int) floor(v * nl)]++;
        counter++;
    }
    *out_counter = counter;
}

void usageError(const char *id) {
    mexErrMsgIdAndTxt(id,
	    "Correct usage: stripped_binfeatures(im, num_bins, mask)\n"
        "    im: grayscale image of type single, all entries must have values in the range [0,1].\n"
        "    (optional) num_bins: specifies the dimension of the output array, must be >= 2.\n"
        "    (optional) mask: it specifies the pixels to consider, must match the dimensions of im and of logical type.");
}

void invalidEntriesError() {
    mexErrMsgIdAndTxt("MATLAB:normglcm:firstInputHasInvalidEntries", 
        "The input im has an entry at with a value outside the expected range of [0,1].");
}