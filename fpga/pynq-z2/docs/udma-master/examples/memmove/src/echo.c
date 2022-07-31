/******************************************************************************
*
* Copyright (C) 2016 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

#include <stdio.h>
#include <string.h>

#include "lwip/sockets.h"
#include "netif/xadapter.h"
#include "lwipopts.h"
#include "xil_printf.h"
#include "FreeRTOS.h"
#include "task.h"
#include "xparameters.h"
#include "xil_io.h"
#include "comblock.h"

#define READ_REG  	0
#define WRITE_REG 	1
#define READ_MEM  	2
#define WRITE_MEM 	3
#define READ_FIFO 	4
#define WRITE_FIFO 	5
#define WRITE_DMA 	6


#define THREAD_STACKSIZE 1024

u16_t echo_port = 7;

void print_echo_app_header()
{
    xil_printf("%20s %6d %s\r\n", "echo server",
                        echo_port,
                        "$ telnet <board_ip> 7");

}

/* thread spawned for each connection */
void process_echo_request(void *p) {
	int sd = (int)p;
	int RECV_BUF_SIZE = 1024;
	int recv_buf[RECV_BUF_SIZE];
	int SEND_BUF_SIZE = 1024;
	int send_buf[SEND_BUF_SIZE];
	int n;
    int pack_type;

    while (1) {

    	/* read a max of RECV_BUF_SIZE bytes from socket */
    	if ((n = read(sd, recv_buf, RECV_BUF_SIZE)) < 0) {
    		xil_printf("%s: error reading from socket %d, closing socket\r\n", __FUNCTION__, sd);
    		break;
		}

		if(n <= 0) {
			xil_printf("chau\n");
			break;
		}

		pack_type=recv_buf[0];
		xil_printf("packet type: %d \n\r",pack_type);

		switch(pack_type) {
			case READ_REG:
				xil_printf("Packet type:%d \t Register:%d \n\r",recv_buf[0], recv_buf[1]);
				send_buf[0] = ComBlock_Read(XPAR_COMBLOCK_0_AXIL_REGS_BASEADDR + 4 * recv_buf[1]);
				xil_printf("Register value:%d \n\r", send_buf[0]);
				write(sd, send_buf, 4);
				break;
			case READ_MEM:
				break;
			case WRITE_REG:
				ComBlock_Write(XPAR_COMBLOCK_0_AXIL_REGS_BASEADDR + 4 * recv_buf[1], recv_buf[2]);
				xil_printf("Write on reg: %d  data: %d \n\r",recv_buf[1], recv_buf[2]);
				break;
			case WRITE_MEM:
				//ComBlock_WriteBulk((uint)XPAR_COMBLOCK_1_AXIF_DRAM_BASEADDR, recv_buf+1, 16);
				xil_printf("Write mem address: 0x%x",recv_buf[1]);
				for (int i=0; i<4; i++){
					xil_printf("Write mem[%d]: 0x%x\n\r",i,recv_buf[2+i]);
				}
				break;
			case WRITE_FIFO:
				for(int i = 0; i < 5; i++) {
					ComBlock_Write(XPAR_COMBLOCK_0_AXIF_FIFO_BASEADDR, i);
					xil_printf("Write to FIFO: %d \n\r",i);
				}
				break;
			case READ_FIFO:
				xil_printf("Reading %d from FIFO.\n\r", recv_buf[1]);
				for (int i=0; i<recv_buf[1]; i++){
					send_buf[i]=Xil_In32(XPAR_COMBLOCK_0_AXIF_FIFO_BASEADDR);
					xil_printf("FIFO[%d]: %d\n\r",i, send_buf[i]);
				}
				write(sd, send_buf, 4*recv_buf[1]);
				break;
			case WRITE_DMA:
				printf("Writing UDMA to BRAM.\n\r");
				int temp =(recv_buf[3] << 16) & 0xffff0000;
				recv_buf[3] = temp + (recv_buf[4] & 0xffff);
				recv_buf[4] = recv_buf[5];
				printf("Writing data: %X. %X. %X. %d.\n\r", recv_buf[1], recv_buf[2], recv_buf[3], recv_buf[4]);
				for (int i=0; i < 4; i++){
					ComBlock_Write(XPAR_COMBLOCK_0_AXIF_DRAM_BASEADDR + 4 * i, recv_buf[i + 1]);
				}
				int a = ComBlock_Read(XPAR_COMBLOCK_0_AXIL_REGS_BASEADDR + 4) & 0x01;
				printf("BUSY : %d \n\r", a);
				ComBlock_Write(XPAR_COMBLOCK_0_AXIL_REGS_BASEADDR, 1);
				ComBlock_Write(XPAR_COMBLOCK_0_AXIL_REGS_BASEADDR, 0);
				a = ComBlock_Read(XPAR_COMBLOCK_0_AXIL_REGS_BASEADDR + 4) & 0x01;
				xil_printf("BUSY : %d \n\r", a);
				int b = 100000;
				do {
					b--;
					a = ComBlock_Read(XPAR_COMBLOCK_0_AXIL_REGS_BASEADDR + 4) & 0x01;
				} while((a > 0) && (b > 0));
//				if (b < 1 ) {
//					xil_printf("FAILURE!!! %d %d \n\r", a, b);
//					write(sd, (uint*) 1, 0);
//				} else {
//					xil_printf("Success %d %d \n\r", a, b);
					write(sd, (uint*) 1, 1);
//				}
				break;
		}
    }
	/* close connection */
	close(sd);
	vTaskDelete(NULL);
}

void echo_application_thread()
{
	int sock, new_sd;
	int size;
#if LWIP_IPV6==0
	struct sockaddr_in address, remote;

	memset(&address, 0, sizeof(address));

	if ((sock = lwip_socket(AF_INET, SOCK_STREAM, 0)) < 0)
		return;

	address.sin_family = AF_INET;
	address.sin_port = htons(echo_port);
	address.sin_addr.s_addr = INADDR_ANY;
#else
	struct sockaddr_in6 address, remote;

	memset(&address, 0, sizeof(address));

	address.sin6_len = sizeof(address);
	address.sin6_family = AF_INET6;
	address.sin6_port = htons(echo_port);

	memset(&(address.sin6_addr), 0, sizeof(address.sin6_addr));

	if ((sock = lwip_socket(AF_INET6, SOCK_STREAM, 0)) < 0)
		return;
#endif

	if (lwip_bind(sock, (struct sockaddr *)&address, sizeof (address)) < 0)
		return;

	lwip_listen(sock, 0);

	size = sizeof(remote);

	while (1) {
		if ((new_sd = lwip_accept(sock, (struct sockaddr *)&remote, (socklen_t *)&size)) > 0) {
		    xil_printf("New connection \n\r");
			sys_thread_new("echos", process_echo_request, (void*)new_sd, THREAD_STACKSIZE * 4, 2);
		}
	}
}

