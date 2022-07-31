library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity QGT_tb is
end entity;

architecture sim of QGT_tb is 

    signal rotAx1: std_logic_vector(3 DOWNTO 0); 
    signal rotAy2: std_logic_vector(3 DOWNTO 0); 
    signal rotAx3: std_logic_vector(3 DOWNTO 0); 
    signal rotBx1: std_logic_vector(3 DOWNTO 0); 
    signal rotBy2: std_logic_vector(3 DOWNTO 0); 
    signal rotBx3: std_logic_vector(3 DOWNTO 0); 
    signal p00:    std_logic_vector(15 DOWNTO 0);
    signal p01:    std_logic_vector(15 DOWNTO 0);
    signal p10:    std_logic_vector(15 DOWNTO 0);
    signal p11:    std_logic_vector(15 DOWNTO 0);
    signal clk: std_logic; 

begin
    top: entity work.QGT_state_fixpt
    port map(rotAx1=>rotAx1, rotAy2=>rotAy2, rotAx3=>rotAx3, rotBx1=>rotBx1, rotBy2=>rotBy2, rotBx3=>rotBx3, p00=>p00, p01=>p01, p10=>p10, p11=>p11);
                
    clock_process: process
    begin
         clk <= '0';
         wait for 5 ns;
         clk <= '1';
         wait for 5 ns;
    end process;
    
    QGT_process: process is
    begin
        rotAx1 <= "0001"; -- 1
        rotAy2 <= "0010"; -- 2
        rotAx3 <= "0011"; -- 3
        rotBx1 <= "1101"; -- 13
        rotBy2 <= "1110"; -- 14
        rotBx3 <= "1111"; -- 15
        wait for 100 ns;
        rotAx1 <= "0000"; -- 1
        rotAy2 <= "0000"; -- 2
        rotAx3 <= "0000"; -- 3
        rotBx1 <= "0000"; -- 13
        rotBy2 <= "0000"; -- 14
        rotBx3 <= "0000"; -- 15
        wait;   
    end process;    
    
end architecture;