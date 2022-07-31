#ifndef QGT_H
#define QGT_H

/* Include files */
#include "rtwtypes.h"
#include <stddef.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Function Declarations */
extern void QGT(int rotAx1, int rotAy2, int rotAx3, int rotBx1,
				int rotBy2, int rotBx3, float *p00, float *p01,
                float *p10, float *p11);

#ifdef __cplusplus
}
#endif

#endif
/* End of code generation (QGT.h) */
