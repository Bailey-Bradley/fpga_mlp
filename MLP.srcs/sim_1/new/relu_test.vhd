----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/14/2026 06:03:24 PM
-- Design Name: 
-- Module Name: relu_test - Behavioral
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

entity relu_test is
--  Port ( );
end relu_test;

architecture Behavioral of relu_test is
    signal input : STD_LOGIC_VECTOR(15 DOWNTO 0);
    signal output : STD_LOGIC_VECTOR(15 DOWNTO 0);
begin
    DUT : entity work.relu
        port map(
            input => input,
            output => output
        );
        
    process begin
        input <= "1011001010101100";
        wait for 2 ns;
        assert(output="0000000000000000") report "Failed 1" severity error;
        wait for 2 ns;
        
        input <= "0111001010101100";
        wait for 2 ns;
        assert(output="0111001010101100") report "Failed 2" severity error;
        wait for 2 ns;
    
    wait;
    end process;

end Behavioral;
