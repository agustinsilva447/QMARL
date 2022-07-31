#include <stdio.h>
#include "comblock.h"
#include "platform.h"
#include "xil_printf.h"
#include "sleep.h"
#include "xparameters.h"


short int float_to_int16(float val)
{
	short int result;
	//union float_bytes{
	//	float v;
	//	unsigned char bytes[4];
	//} data;
	//data.v = val;
	//result = (data.bytes[3]<<24) + (data.bytes[2]<<16) + (data.bytes[1]<<8) + (data.bytes[0]);
	return result;
}

float int16_to_float(short int val)
{
	union{
		float val_float;
		unsigned char bytes[4];
	} data;
	//data.bytes[3] = (val >> (8*3)) & 0xff;
	//data.bytes[2] = (val >> (8*2)) & 0xff;
	//data.bytes[1] = (val >> (8*1)) & 0xff;
	//data.bytes[0] = (val >> (8*0)) & 0xff;
	return data.val_float;
}

int main()
{
    init_platform();
    short int a_re, a_im, b_re, b_im, c_re, c_im;

    a_re = -1638; // 1111100110011010; // -0.2;
    a_im =  2540; // 0000100111101100; // 0.31;
    b_re =  2048; // 0000100000000000; // 0.25;
    b_im = -5734; // 1110100110011010; // -0.7;


    cbWrite(XPAR_COMBLOCK_0_AXIL_BASEADDR, CB_OREG0, (a_re));
    cbWrite(XPAR_COMBLOCK_0_AXIL_BASEADDR, CB_OREG1, (a_im));
    cbWrite(XPAR_COMBLOCK_0_AXIL_BASEADDR, CB_OREG2, (b_re));
    cbWrite(XPAR_COMBLOCK_0_AXIL_BASEADDR, CB_OREG3, (b_im));

    sleep(1);

    c_re = (cbRead(XPAR_COMBLOCK_0_AXIL_BASEADDR, CB_IREG0));
    c_im = (cbRead(XPAR_COMBLOCK_0_AXIL_BASEADDR, CB_IREG1));

    sleep(1);

    printf("(%hd + i* %hd) * (%hd + i* %hd) = (%hd + i* %hd)", a_re, a_im, b_re, b_im, c_re, c_im);
    cleanup_platform();
    return 0;
}
