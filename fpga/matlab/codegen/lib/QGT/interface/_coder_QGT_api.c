/*
 * _coder_QGT_api.c
 *
 * Code generation for function 'QGT'
 *
 */

/* Include files */
#include "_coder_QGT_api.h"
#include "_coder_QGT_mex.h"

/* Variable Definitions */
emlrtCTX emlrtRootTLSGlobal = NULL;

emlrtContext emlrtContextGlobal = {
    true,                                                 /* bFirstTime */
    false,                                                /* bInitialized */
    131610U,                                              /* fVersionInfo */
    NULL,                                                 /* fErrorFunction */
    "QGT",                                                /* fFunctionName */
    NULL,                                                 /* fRTCallStack */
    false,                                                /* bDebugMode */
    {2045744189U, 2170104910U, 2743257031U, 4284093946U}, /* fSigWrd */
    NULL                                                  /* fSigMem */
};

/* Function Declarations */
static real_T b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                                 const emlrtMsgIdentifier *parentId);

static real_T c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
                                 const emlrtMsgIdentifier *msgId);

static real_T emlrt_marshallIn(const emlrtStack *sp, const mxArray *rotAx1,
                               const char_T *identifier);

static const mxArray *emlrt_marshallOut(const real_T u);

/* Function Definitions */
static real_T b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                                 const emlrtMsgIdentifier *parentId)
{
  real_T y;
  y = c_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static real_T c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
                                 const emlrtMsgIdentifier *msgId)
{
  static const int32_T dims = 0;
  real_T ret;
  emlrtCheckBuiltInR2012b((emlrtCTX)sp, msgId, src, (const char_T *)"double",
                          false, 0U, (void *)&dims);
  ret = *(real_T *)emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

static real_T emlrt_marshallIn(const emlrtStack *sp, const mxArray *rotAx1,
                               const char_T *identifier)
{
  emlrtMsgIdentifier thisId;
  real_T y;
  thisId.fIdentifier = (const char_T *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = b_emlrt_marshallIn(sp, emlrtAlias(rotAx1), &thisId);
  emlrtDestroyArray(&rotAx1);
  return y;
}

static const mxArray *emlrt_marshallOut(const real_T u)
{
  const mxArray *m;
  const mxArray *y;
  y = NULL;
  m = emlrtCreateDoubleScalar(u);
  emlrtAssign(&y, m);
  return y;
}

void QGT_api(const mxArray *const prhs[6], int32_T nlhs, const mxArray *plhs[4])
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  real_T p00;
  real_T p01;
  real_T p10;
  real_T p11;
  real_T rotAx1;
  real_T rotAx3;
  real_T rotAy2;
  real_T rotBx1;
  real_T rotBx3;
  real_T rotBy2;
  st.tls = emlrtRootTLSGlobal;
  /* Marshall function inputs */
  rotAx1 = emlrt_marshallIn(&st, emlrtAliasP(prhs[0]), "rotAx1");
  rotAy2 = emlrt_marshallIn(&st, emlrtAliasP(prhs[1]), "rotAy2");
  rotAx3 = emlrt_marshallIn(&st, emlrtAliasP(prhs[2]), "rotAx3");
  rotBx1 = emlrt_marshallIn(&st, emlrtAliasP(prhs[3]), "rotBx1");
  rotBy2 = emlrt_marshallIn(&st, emlrtAliasP(prhs[4]), "rotBy2");
  rotBx3 = emlrt_marshallIn(&st, emlrtAliasP(prhs[5]), "rotBx3");
  /* Invoke the target function */
  QGT(rotAx1, rotAy2, rotAx3, rotBx1, rotBy2, rotBx3, &p00, &p01, &p10, &p11);
  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(p00);
  if (nlhs > 1) {
    plhs[1] = emlrt_marshallOut(p01);
  }
  if (nlhs > 2) {
    plhs[2] = emlrt_marshallOut(p10);
  }
  if (nlhs > 3) {
    plhs[3] = emlrt_marshallOut(p11);
  }
}

void QGT_atexit(void)
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  QGT_xil_terminate();
  QGT_xil_shutdown();
  emlrtExitTimeCleanup(&emlrtContextGlobal);
}

void QGT_initialize(void)
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, NULL);
  emlrtEnterRtStackR2012b(&st);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

void QGT_terminate(void)
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (_coder_QGT_api.c) */
