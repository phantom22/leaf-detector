#include "mex.h"
#include "matrix.h"
#include <math.h>

/* Input Arguments */
#define	IM      pts_rhs[0]
#define	NL      pts_rhs[1]
#define	MASK    pts_rhs[2]

/* Output Arguments */
#define OUT     pts_lhs[0]

/* Prototypes */
void computeMaskGLCM(mxDouble *OUTPTR, int *out_counter, mxSingle *IMPTR, mxLogical *MASKPTR, mwSize m, mwSize n, int nl);
void computeGLCM(mxDouble *OUTPTR, int *out_counter, mxSingle *IMPTR, mwSize m, mwSize n, int nl);
void usageError(const char *id);

void mexFunction(int num_args_lhs, mxArray *pts_lhs[], int num_rhs, const mxArray *pts_rhs[]) {
    if (num_args_lhs > 1)
        mexErrMsgIdAndTxt("MATLAB:normglcm:invalidNumOutputs",
			"Invalid number of output arguments.\n  out_args: glcm.");

    size_t nDimNum;
    const mwSize *pDims;
    mwSize m, n;
    int NLVAL = 8;
    mxLogical *MASKPTR;
    int with_mask = 0;
    if (num_rhs > 0 && num_rhs < 4) {
        if (!mxIsSingle(IM) || mxIsComplex(IM))
		    usageError("MATLAB:normglcm:firstInputNotSingle");
        nDimNum = mxGetNumberOfDimensions(IM);
	    pDims = mxGetDimensions(IM);
        if (nDimNum != 2)
		    usageError("MATLAB:normglcm:firstInputNot2DArray");
        m = pDims[0];
        n = pDims[1];
        if (m <= 1 || n <= 1)
		    usageError("MATLAB:normglcm:firstInputNotMatrix");

        if (num_rhs >= 2) {
            if (!mxIsDouble(NL) || !mxIsScalar(NL)) 
                usageError("MATLAB:normglcm:secondInputNotDouble");
            NLVAL = (int) mxGetScalar(NL);
            if (NLVAL < 2)
                usageError("MATLAB:normglcm:secondInputLessThanTwo");
        }

        if (num_rhs == 3) {
            if (!mxIsLogical(MASK))
                usageError("MATLAB:normglcm:thirdInputNotLogical");
            else if (m != mxGetM(MASK) || n != mxGetN(MASK))
                usageError("MATLAB:normglcm:thirdInputInvalidDims");
            with_mask = 1;
            MASKPTR = (mxLogical *) mxGetData(MASK);
        }
    }
    else
        usageError("MATLAB:normglcm:invalidNumInputs");

    /* Get pointer to input image */
    mxSingle *IMPTR = (mxSingle *) mxGetData(IM);

    mwSize outDims[2] = {NLVAL, NLVAL};
    /* allocate memory for output image */
    OUT = mxCreateNumericArray(2, outDims, mxDOUBLE_CLASS, mxREAL);
    /* Get pointer to output image */
    mxDouble *OUTPTR = (mxDouble *) mxGetData(OUT);
    
    int occurrence_count = 0;

    if (with_mask)
        computeMaskGLCM(OUTPTR, &occurrence_count, IMPTR, MASKPTR, m, n, NLVAL);
    else
        computeGLCM(OUTPTR, &occurrence_count, IMPTR, m, n, NLVAL);

    // normalize the glcm matrix
    for (int i=0; i<NLVAL*NLVAL; i++) {
        OUTPTR[i] /= occurrence_count;
    }

    /* Return results to Matlab workspace */
    return;
}

void computeMaskGLCM(mxDouble *OUTPTR, int *out_counter, mxSingle *IMPTR, mxLogical *MASKPTR, mwSize m, mwSize n, int nl) {
    int curr, next, counter  = 0;

    for (int x=0; x<n-1; x++) {
        for (int y=0; y<m; y++) {
            if (!MASKPTR[y+x*m])
                continue;
            else
                curr = (int) floor(IMPTR[y+x*m] * nl);

            next = (int) floor(IMPTR[y+(x+1)*m] * nl);

            OUTPTR[curr*nl + next]++;
            curr = next;
            counter++;
        }
    }

    *out_counter = counter;
}

void computeGLCM(mxDouble *OUTPTR, int *out_counter, mxSingle *IMPTR, mwSize m, mwSize n, int nl) {
    int curr, next, counter = 0;
    for(int x=0; x<n-1; x++) {
        for(int y=0; y<m; y++) {
            if (x == 0)
                curr = (int) floor(IMPTR[y+x*m] * nl);
            next = (int) floor(IMPTR[y+(x+1)*m] * nl);
            OUTPTR[curr*nl + next]++;
            curr = next;
            counter++;
        }
    }
    *out_counter = counter;
}

void usageError(const char *id) {
    mexErrMsgIdAndTxt(id,
	    "Correct usage: normglcm(im, num_levels, mask)\n"
        "    im: grayscale image of type single.\n"
        "    (optional) num_levels: specifies the dimensions of the output matrix, must be >= 2.\n"
        "    (optional) mask: it specifies the pixels to consider, must match the dimensions of im and of logical type.");
}