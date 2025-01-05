#include "mex.h"
#include "matrix.h"
#include <math.h>

/* Input Arguments */
#define	IM       pts_rhs[0]
#define	NUM_BINS pts_rhs[1]
#define	MASK     pts_rhs[2]

/* Output Arguments */
#define OUT     pts_lhs[0]

/* Prototypes */
void computeMaskBins(mxDouble *OUTPTR, int *out_counter, mxSingle *IMPTR, mxLogical *MASKPTR, mwSize m, mwSize n, int nl);
void computeBins(mxDouble *OUTPTR, int *out_counter, mxSingle *IMPTR, mwSize m, mwSize n, int nl);
void usageError(const char *id);
void invalidEntriesError();

void mexFunction(int num_args_lhs, mxArray *pts_lhs[], int num_rhs, const mxArray *pts_rhs[]) {
    if (num_args_lhs > 1)
        mexErrMsgIdAndTxt("MATLAB:normbins:invalidNumOutputs",
			"Invalid number of output arguments.\n  out_args: normalized_bins.");

    size_t nDimNum;
    const mwSize *pDims;
    mwSize m, n;
    int NLVAL = 8;
    mxLogical *MASKPTR;
    int with_mask = 0;

    if (num_rhs > 0 && num_rhs < 4) {
        if (!mxIsSingle(IM) || mxIsComplex(IM))
            usageError("MATLAB:normbins:firstInputNotSingle");
        nDimNum = mxGetNumberOfDimensions(IM);
	    pDims = mxGetDimensions(IM);
        if (nDimNum != 2)
		    usageError("MATLAB:normbins:firstInputNot2DArray");
        m = pDims[0];
        n = pDims[1];
        if (num_rhs >= 2) {
            if (!mxIsDouble(NUM_BINS) || !mxIsScalar(NUM_BINS)) 
                usageError("MATLAB:normbins:secondInputNotDouble");
            NLVAL = (int) mxGetScalar(NUM_BINS);
            if (NLVAL < 2)
                usageError("MATLAB:normbins:secondInputLessThanTwo");
        }
        if (num_rhs == 3) {
            if (!mxIsLogical(MASK))
                usageError("MATLAB:normbins:thirdInputNotLogical");
            else if (m != mxGetM(MASK) || n != mxGetN(MASK))
                usageError("MATLAB:normbins:thirdInputInvalidDims");
            with_mask = 1;
            MASKPTR = (mxLogical *) mxGetData(MASK);
        }
    }
    else
        usageError("MATLAB:normbins:invalidNumInputs");
    
    /* Get pointer to input image */
    mxSingle *IMPTR = (mxSingle *) mxGetData(IM);

    mwSize outDims[2] = {NLVAL, 1};
    /* allocate memory for output image */
    OUT = mxCreateNumericArray(2, outDims, mxDOUBLE_CLASS, mxREAL);
    /* Get pointer to output image */
    mxDouble *OUTPTR = (mxDouble *) mxGetData(OUT);
    
    int occurrence_count = 0;

    if (with_mask)
        computeMaskBins(OUTPTR, &occurrence_count, IMPTR, MASKPTR, m, n, NLVAL);
    else
        computeBins(OUTPTR, &occurrence_count, IMPTR, m, n, NLVAL);

    // normalize the bins to a probability distribution
    for (int i=0; i<NLVAL; i++) {
        OUTPTR[i] /= occurrence_count;
    }

    /* Return results to Matlab workspace */
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
	    "Correct usage: normbins(im, num_bins, mask)\n"
        "    im: grayscale image of type single, all entries must have values in the range [0,1].\n"
        "    (optional) num_bins: specifies the dimension of the output array, must be >= 2.\n"
        "    (optional) mask: it specifies the pixels to consider, must match the dimensions of im and of logical type.");
}

void invalidEntriesError() {
    mexErrMsgIdAndTxt("MATLAB:normglcm:firstInputHasInvalidEntries", 
        "The input im has an entry at with a value outside the expected range of [0,1].");
}