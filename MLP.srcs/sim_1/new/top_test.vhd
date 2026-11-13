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
begin

top : entity work.top
    port map (
        clk => clk,
        go => go
    );
    
process begin

    go <= '0';

    for i in 1 to 5 loop
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
    end loop;
    
    go <= '1';
    
    for i in 1 to 787 loop
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
    end loop;
    
    wait;
end process;

end Behavioral;
