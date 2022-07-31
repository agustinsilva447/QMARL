# Instructions to implement the examples

## Vivado project instructions

1. Clone the git project into your PC.
2. Create a new project in Vivado.
3. Run the tcl file provided in the ```examples``` folder.
4. Create the HDL wrapper.
5. Generate output products.
6. Generate bitstream.
7. Export hardware, remember to include the bitstream.

## SDK or Vitis instructions

1. Launch SDK.
2. Create an Application Project.
3. Select FreeRTOS.
4. Create a LWIP Echo server example.
5. Modify BSP settings. On FreeRTOS go to kernel_behavior tab and change total_heap_size to 262144. This will regenerate the BSP.
6. Got to the project folder in the Project Explorer, left click in the src folder and select Import.
7. In the General tab select File System.
8. Browse your PC to the src folder of the repo.
9. Select the `udma.h` file and the `echo.c` file.

## Implementation

1. Build the project.
2. Connect the ZedBoard programming USB cable.
3. Connect Ethernet cable and UART USB cable.
4. Program the FPGA and run the project.
5. Run the Python CLI.
6. Enjoy!

## Troubleshooting

### No serial port available

Check the USB cable.
Make sure your OS is running the latest drivers.
Check that your serial terminal is running at 115200.

### Unable to connect to the board via Ethernet

Check that the IP address is valid by pinging the board.
Check the serial terminal for any errors.
