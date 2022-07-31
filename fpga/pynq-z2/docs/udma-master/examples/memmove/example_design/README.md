# **memmove** Example Design

Simple example design for testing the **memmove** module.
This example includes two peripherals from which move data from/to. The peripheral connected to the port `S1` is a simple BRAM meanwhile the peripheral connected to `S4` is(are) the fifo(s) from the `comblock` IP (which allows moving data between PL and PS without the need of a propietary IP).

The **_UDMA_** instruction is read from the BRAM of the `comblock` (always assuming adjacent positions), and the start to parse flag from the `lsb` of the register 0 (i.e. `reg0_o(0)`). The `busy` and `done`flags are reported to the bits 0 and 1 of the register 0 input (i.e. `reg0_i(0)` and `reg0_i(1)`) respectively.

A simplified diagram is shown below:

``` 
                                                                       +---------+
                                                                       |         |
                                                                       |         |
                                                                +----->+         |
                                                                |      |  BRAM   |
   comblock                +-----------+         +--------+     |      |         |
 ~-----------+             |           |         |        | S1  |      |         |
             |  start      |           |         |   +-----<----+      |         |
   reg0_o(0) +------------>+           |         |   |    |            +---------+
             |  busy       |           |         |   +-----<-> S2
   reg0_i(0) +<------------+  memmove  +<------->----+    |          comblock
             |  done       |           |         |   +-----<-> S3    +-------------~
   reg0_i(1) +<------------+           |         |   |    |          | |---------+
             |             |           |         |   +-----<----+    | || ||
  +------+   |      +----->+           |         |        | S4  |    | +---------+
  |      |   |      |      +-----------+         +--------+     +--->+
  | BRAM +----------+                           interconnect         | +---------+
  |      |   |  cmd                                                  |        || |
  +------+   |                                                       | +---------+
~------------+                                                       +-------------~
  (regs and                                                          (FIFOs only)
   BRAM only)
```

## Generation:
On _Vivado_ `tcl` console simply `source example.tcl`.
This will generate a subfolder with the vivado project ready to be sinthesized/implemented.

Examples using other tools from other vendors will be added over time.