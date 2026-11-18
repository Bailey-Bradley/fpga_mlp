----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/12/2026 10:09:33 PM
-- Design Name: 
-- Module Name: top_test - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_test is
end top_test;

architecture Behavioral of top_test is
    signal clk : STD_LOGIC;
    signal go : STD_LOGIC;
    
    signal sw0: std_logic;
    signal sw1: std_logic;
    signal sw2: std_logic;
    signal sw3: std_logic;
begin

top : entity work.top
    port map (
        clk => clk,
        go => go,
        
        sw0 => sw0,
        sw1 => sw1,
        sw2 => sw2,
        sw3 => sw3
    );
    
process begin

    sw0 <= '0';
    sw1 <= '1';
    sw2 <= '0';
    sw3 <= '0';

    go <= '0';

    for i in 1 to 5 loop
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
    end loop;
    
    go <= '1';
    
    for i in 1 to 500000 loop
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
    end loop;
    
    wait;
end process;

end Behavioral;
