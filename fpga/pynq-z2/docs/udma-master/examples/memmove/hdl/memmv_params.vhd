------------------------------------------------------------------------------------
-- memmv_params
--
--
--
-- Autor: E. Marchi - M. Cervetto
-- Revisión: 0.1 -- inicial
-------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package memmv_params is
  
  constant BUS_DATA_WIDTH : natural                           := 32;
  constant BUS_ADDR_WIDTH : natural                           := 32;

  constant CMD_DATA_WIDTH : natural                           := 32; --must be equal to BUS_ADDR_WIDTH
  constant CMD_ADDR_WIDTH : natural                           := 10;
  constant CMD_BASE_ADDR  : std_logic_vector(CMD_ADDR_WIDTH - 1 downto 0) := (others => '0');
  

  type dma_instr_type is record
    source_addr : std_logic_vector(BUS_ADDR_WIDTH - 1 downto 0);
    dest_addr   : std_logic_vector(BUS_ADDR_WIDTH - 1 downto 0);
    source_incr : std_logic_vector(BUS_ADDR_WIDTH/2 - 1 downto 0);
    dest_incr   : std_logic_vector(BUS_ADDR_WIDTH/2 - 1 downto 0);
    move_size   : std_logic_vector(BUS_ADDR_WIDTH - 1 downto 0);
  end record;


end package;
