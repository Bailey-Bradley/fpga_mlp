----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/14/2026 04:27:10 PM
-- Design Name: 
-- Module Name: relu - Behavioral
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

-- separate relu module where you can set what the input width is
entity relu is
    generic (
        WIDTH : integer := 16 -- set based on width of input data
    );
    Port ( input : in STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
           output : out STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0));
end relu;

architecture Behavioral of relu is
begin
    process(input)
    begin
        if input(WIDTH - 1) = '1' then
            output <= (others => '0');
        else
            output <= input;
        end if;
    end process;
end Behavioral;
