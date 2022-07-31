/*
 * _coder_quantum_minority_mex.h
 *
 * Code generation for function 'quantum_minority'
 *
 */

#ifndef _CODER_QUANTUM_MINORITY_MEX_H
#define _CODER_QUANTUM_MINORITY_MEX_H

/* Include files */
#include "emlrt.h"
#include "mex.h"
#include "tmwtypes.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Function Declarations */
MEXFUNCTION_LINKAGE void mexFunction(int32_T nlhs, mxArray *plhs[],
                                     int32_T nrhs, const mxArray *prhs[]);

emlrtCTX mexFunctionCreateRootTLS(void);

void unsafe_quantum_minority_mexFunction(int32_T nlhs, mxArray *plhs[1],
                                         int32_T nrhs, const mxArray *prhs[6]);

#ifdef __cplusplus
}
#endif

#endif
/* End of code generation (_coder_quantum_minority_mex.h) */
