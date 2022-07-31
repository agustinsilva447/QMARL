#ifndef UDMA_H
#define UDMA_H

#include <stdio.h>
#include <string.h>
#include "comblock.h"

#define true 1
#define false 0

#include "xparameters.h"
#include "comblock_config.h"

#define READ_REG           0
#define READ_RAM           1
#define READ_MEM           2
#define READ_FIFO          3
/*---------------------------------*/
#define WRITE_REG          4
#define WRITE_RAM          5
#define WRITE_MEM          6
#define WRITE_FIFO         7
/*---------------------------------*/
#define UDMA               8
#define SELECT_COMBLOCK    9
/*---------------------------------*/
#define LOG				   255
#define BUFF_SIZE          4096

/*
Write process:
	check if resource is available in case of specific commands
	check if memory is reachable in case of udma or mem
	check if width of word is compatible
		return success or fail

read process
	check if resource is available in case of specific commands
	check if memory is reachable in case of udma or mem
		return success or fail

send_buf [0] error report:
	0 -> Failure
	1 -> Success
	2 -> overflow
	3 -> underflow
	4 -> logging enabled
	5 -> logging disabled
send_buf [1] length
*/

u32 logging 			= true;
u32 XPAR_COMBLOCK_ID 	= 0;

void read_FIFO(UINTPTR baseaddr, u32 *send_buf, u32 length) {
	volatile u32 i = 0;
	while(!(cbRead(baseaddr, CB_IFIFO_STATUS) & 0x01) && (i < length)) {
		send_buf[i + 2] = cbRead(baseaddr, CB_IFIFO_VALUE);
		i++;
		send_buf[1] = i;
	}
	send_buf[0] = 1;
    if (cbRead(baseaddr, CB_IFIFO_STATUS) & 0x04) {
    	send_buf[0] = 3; // if underflow there was an error
    }
}

void write_FIFO(UINTPTR baseaddr, u32 *recv_buf, u32 length, u32 *send_buf) {
	volatile u32 i = 0;
	while(!(cbRead(baseaddr, CB_IFIFO_STATUS) & 0x01) && (i < length)) {
		cbWrite(baseaddr, CB_OFIFO_VALUE, recv_buf[i + 2]);
		i++;
		send_buf[1] = i;
	}
    if (cbRead(baseaddr, CB_OFIFO_STATUS) & 0x04) {
    	send_buf[0] = 2; // if overflow there was an error
    } else {
    	send_buf[0] = 1;
    }
}

void read_RAM(UINTPTR baseaddr, UINTPTR offset, u32 *send_buf, u32 length, u32 inc) {
	if (inc == 1) {
		if(logging)
			xil_printf("Reading: %d, %d, %d \n\r", baseaddr + offset, length, inc);
		cbReadBulk((int *)(send_buf + 2), baseaddr + offset, length);
		send_buf[1] = length;
	} else {
		volatile u32 i;
		for (i = 0; i < length; i ++) {
			if (logging)
				xil_printf("Reading: %d, %d \n\r", baseaddr + offset, i * inc * 4);
			send_buf[i + 2]= cbRead(baseaddr + offset, i * inc);
			send_buf[1] = i;
		}
	}
	send_buf[0] = 1;
}

void write_RAM(UINTPTR baseaddr, UINTPTR offset, u32 *recv_buf, u32 length, u32 inc, u32 *send_buf) {
	if (inc == 1) {
		if(logging)
			xil_printf("Writing: %d, %d \n\r", baseaddr + offset, (int *)(recv_buf + 5));
		cbWriteBulk(baseaddr + offset, (int *) (recv_buf + 5), length);
		send_buf[1] = length;
	}else {
		volatile u32 i;
		for (i = 0; i < length; i ++) {
			if(logging)
				xil_printf("Writing: %d, %d, %d \n\r", baseaddr + offset, i * 4 * inc, recv_buf[i + 5]);
			cbWrite(baseaddr + offset, i * inc, recv_buf[i + 5]);
			send_buf[1] = i;
		}
	}
	send_buf[0] = 1;
}

void read_MEM(UINTPTR baseaddr, u32 *send_buf, u32 length, u32 inc) {
	if (inc == 1) {
		memmove((UINTPTR *)baseaddr, send_buf + 2, length);
		send_buf[1] = length;
	} else {
		volatile u32 i;
		for (i = 0; i < length; i ++) {
			send_buf[i + 2]= cbRead(baseaddr, i * inc);
			send_buf[1] = i;
		}
	}
	send_buf[0] = 1; // success always assumed, unprotected operations are responsibility of the user
}

void write_MEM(UINTPTR baseaddr, u32 *recv_buf, u32 length, u32 inc, u32 *send_buf) {
	if (inc == 1) {
		memmove((UINTPTR *)baseaddr, recv_buf, length);
		send_buf[1] = length;
	} else {
		volatile u32 i;
		for (i = 0; i < length; i ++) {
			cbWrite(baseaddr, i * inc, recv_buf[i + 5]);
			send_buf[1] = i;
		}
	}
	send_buf[0] = 1; // success always assumed, unprotected operations are responsibility of the user
}

int process_command(u32 *recv_buf, int sd) {
	u32 send_buf[BUFF_SIZE];
	send_buf[0] = 0; // always error unless a successful operation
	send_buf[1] = 0; // data length always 0 unless a successful or partially successful operation
	u32 pack_type = recv_buf[0];
	if(logging)
		xil_printf("\n------- Packet type:\t %d -------\n\r",pack_type);
	u32 i = 0;
	switch(pack_type){
		case READ_REG:
			if(logging)
				xil_printf("Register:\t %u \n\r", recv_buf[1]);
			if (XComblock_ConfigTable[XPAR_COMBLOCK_ID].REGS_IN_ENA || (recv_buf[1] > 31)) {
				send_buf[2] = cbRead(XComblock_ConfigTable[XPAR_COMBLOCK_ID].AXIL_BASEADDR, recv_buf[1]);
				send_buf[1] = 1;
				send_buf[0] = 1;
				if(logging) {
					xil_printf("Error code: %u \n\r", send_buf[0]);
					xil_printf("Data length: %u \n\r", send_buf[1]);
					xil_printf("Read value:\t %u \n\r", send_buf[2]);
				}
				write(sd, send_buf, 2 * 4);
				write(sd, send_buf + 2, 4);
			} else
				write(sd, send_buf, 2 * 4);
			break;
		case READ_RAM:
			if(logging)
				xil_printf("Address:\t %u N:\t %u Inc:\t %u\n\r",
						recv_buf[1], recv_buf[2], recv_buf[3]);
			if (XComblock_ConfigTable[XPAR_COMBLOCK_ID].DRAM_IO_ENA) {
				if((recv_buf[1] + recv_buf[2] * recv_buf[3]) > XComblock_ConfigTable[XPAR_COMBLOCK_ID].DRAM_IO_DEPTH)
						send_buf[0] = 2; // if overflow there was an error
					else
						read_RAM(XComblock_ConfigTable[XPAR_COMBLOCK_ID].AXIF_BASEADDR, (UINTPTR) recv_buf[1] * 4,
								send_buf, recv_buf[2], recv_buf[3]);
				if(logging) {
					xil_printf("Error code: %u \n\r", send_buf[0]);
					xil_printf("Data length: %u \n\r", send_buf[1]);
					for(i = 2; i < send_buf[1] + 2; i++)
						xil_printf("data: %u \n\r", send_buf[i]);
				}
				write(sd, send_buf, 2 * 4);
				write(sd, send_buf + 2 , send_buf[1] * 4);
			} else
				write(sd, send_buf, 2 * 4);
			break;
		case READ_MEM:
			if(logging) {
				xil_printf("Warning, unprotected operation!");
				xil_printf("Address:\t %u N:\t %u Inc:\t %u\n\r",
						recv_buf[1], recv_buf[2], recv_buf[3]);
			}
			if(!(recv_buf[1] % 4))
				read_MEM((UINTPTR) recv_buf[1], send_buf, recv_buf[2], recv_buf[3]);
			else {
				if(logging)
					printf("Address must be a multiple of 4 due to the data width (4 bytes).\n\r");
			}
			if(logging) {
				xil_printf("Error code: %u \n\r", send_buf[0]);
				xil_printf("Data length: %u \n\r", send_buf[1]);
				for(i = 2; i < send_buf[1] + 2; i++)
					xil_printf("data: %u \n\r", send_buf[i]);
			}
			write(sd, send_buf, 2 * 4);
			write(sd, send_buf + 2 , send_buf[1] * 4);
			break;
		case READ_FIFO:
			if(logging)
				xil_printf("FIFO N:\t %u \n\r", recv_buf[1]);
			if (XComblock_ConfigTable[XPAR_COMBLOCK_ID].FIFO_IN_ENA) {
				read_FIFO(XComblock_ConfigTable[XPAR_COMBLOCK_ID].AXIL_BASEADDR, send_buf, recv_buf[1]);
				write(sd, send_buf, 2 * 4);
				write(sd, send_buf + 2 , send_buf[1] * 4);
				if(logging) {
					xil_printf("Error code: %u \n\r", send_buf[0]);
					xil_printf("Data length: %u \n\r", send_buf[1]);
					for(i = 2; i < send_buf[1] + 2; i++)
						xil_printf("Data: %u \n\r", send_buf[i]);
				}
			} else
				write(sd, send_buf, 2 * 4);
			break;
		case WRITE_REG:
			if(logging)
				xil_printf("Register:\t %u Data:\t %u \n\r",recv_buf[1],recv_buf[2]);
			if (XComblock_ConfigTable[XPAR_COMBLOCK_ID].REGS_OUT_ENA) {
				cbWrite(XComblock_ConfigTable[XPAR_COMBLOCK_ID].AXIL_BASEADDR, recv_buf[1] + 16, recv_buf[2]);
				send_buf[1] = 1;
				send_buf[0] = 1;
			}
			write(sd, send_buf, 2 * 4);
			break;
		case WRITE_RAM:
			if(logging) {
				xil_printf("Address:\t %u N:\t %u Inc:\t %u Radix:\t %u\n\r",
						recv_buf[1], recv_buf[2], recv_buf[3], recv_buf[4]);
				for(i = 0; i < recv_buf[2]; i++)
					xil_printf("Data: %u \n\r", recv_buf[i + 5]);
			}
			if (XComblock_ConfigTable[XPAR_COMBLOCK_ID].DRAM_IO_ENA) {
				if(logging)
					xil_printf("Resources available\n\r");
				if((recv_buf[1] + recv_buf[2] * recv_buf[3]) > XComblock_ConfigTable[XPAR_COMBLOCK_ID].DRAM_IO_DEPTH)
					send_buf[0] = 2;
				else
					write_RAM(XComblock_ConfigTable[XPAR_COMBLOCK_ID].AXIF_BASEADDR, recv_buf[1] * 4,
							recv_buf, (UINTPTR) recv_buf[2], recv_buf[3], send_buf);
				if(logging) {
					xil_printf("Error code: %u \n\r", send_buf[0]);
					xil_printf("Data length: %u \n\r", send_buf[1]);
				}
			}
			write(sd, send_buf, 2 * 4);
			break;
		case WRITE_MEM:
			if(logging) {
				xil_printf("Warning, non protected operation!\n\r");
				xil_printf("Address:\t %u N:\t %u Inc:\t %u Radix:\t %u\n\r",
						recv_buf[1], recv_buf[2], recv_buf[3], recv_buf[4]);
				for(i = 0; i < recv_buf[2]; i++)
					xil_printf("Data: %u \n\r", recv_buf[i + 5]);
			}
			if(!(recv_buf[1] % 4))
				write_MEM(recv_buf[1], recv_buf, recv_buf[2], recv_buf[3], send_buf);
			else {
				if(logging) {
					xil_printf("Error code: %u \n\r", send_buf[0]);
					xil_printf("Data length: %u \n\r", send_buf[1]);
				}
			}
			write(sd, send_buf, 2 * 4);
			break;
        case WRITE_FIFO:
        	if(logging) {
        		xil_printf("FIFO N:\t %u \n\r", recv_buf[1]);
        		for(i = 0; i < recv_buf[1]; i++)
        			xil_printf("Data: %u \n\r", recv_buf[i + 2]);
        	}
			if (XComblock_ConfigTable[XPAR_COMBLOCK_ID].FIFO_OUT_ENA) {
				write_FIFO(XComblock_ConfigTable[XPAR_COMBLOCK_ID].AXIL_BASEADDR, recv_buf, recv_buf[1], send_buf);
			}
			write(sd, send_buf, 2 * 4);
            break;
		case UDMA:
			// write in special memory for UDMA module to process
			break;
		case SELECT_COMBLOCK:
			if(logging) {
				xil_printf("Change active ComBlock. \r\n");
			}
			if ((XPAR_COMBLOCK_NUM_INSTANCES > 1) && (XPAR_COMBLOCK_NUM_INSTANCES - recv_buf[1]) > 0) {
				if(logging)
					xil_printf("Active ComBlock:\t %u \n", recv_buf[1]);
				XPAR_COMBLOCK_ID = recv_buf[1];
				send_buf[0] = 1;
			} else{
				if(logging)
					xil_printf("ComBlock ID is not valid:\t %u \r\n", send_buf[1]);
				XPAR_COMBLOCK_ID = 0 ;
				send_buf[0] = 0;
			}
			write(sd, send_buf, 2 * 4);
			break;
		case LOG:
			if(recv_buf[1]) {
				logging = true;
				xil_printf("Logging enabled. \n\r");
				send_buf[0] = 4;
			}else{
				logging = false;
				xil_printf("Logging disabled. \n\r");
				send_buf[0] = 5;
			}
			write(sd, send_buf, 4);
		default:
			break;

	}
	return send_buf[0];
}

#endif //UDMA_H
