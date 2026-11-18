----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2026 06:25:18 PM
-- Design Name: 
-- Module Name: max_register - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- for any given inference this is the module that constantly checks if a given input is higher than the stored value, providing the index (for the digit!)
entity max_register is
    Port ( en : in STD_LOGIC;
           clk : in STD_LOGIC;
           input_val : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           input_idx : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           output_value : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           output_idx : out STD_LOGIC_VECTOR(3 DOWNTO 0));
end max_register;

architecture Behavioral of max_register is
    signal max_value : SIGNED(31 DOWNTO 0) := x"80000000"; -- start as the most negative number
    signal max_idx : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if en = '1' then
                if signed(input_val) > max_value then
                    max_value <= signed(input_val);
                    max_idx <= input_idx;
                end if;
            end if;        
        end if;
    end process;
    output_value <= STD_LOGIC_VECTOR(max_value);
    output_idx <= max_idx;
end Behavioral;
