----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/13/2026 09:42:54 PM
-- Design Name: 
-- Module Name: neuronupdater - Behavioral
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


-- This is the module that actually takes a RELU'd input neuron, multiplies it by the weight, and updates the target output neuron.
entity neuronupdater is
    Port ( 
           clk : in STD_LOGIC;
           en : in STD_LOGIC; -- if 0: dont react to any input changes
           ready : in STD_LOGIC; -- will be pulsed for one clock cycle to know we want to update the neuron
           input_neuron : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           weight : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           current : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           output : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           done : out STD_LOGIC); -- pulsed for one clock cycle so neuron_src_index knows when its time to increment
end neuronupdater;

architecture Behavioral of neuronupdater is
    signal done_reg : STD_LOGIC := '0';
    signal output_reg : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
begin
    process(clk)
        variable temp_out : signed(39 DOWNTO 0); -- multiplying the 32 bit input neuron by the weight forces a 40 bit output so
    begin
        if rising_edge(clk) then   
            done_reg <= '0'; -- set high for only one clock cycle     
            if en = '1' and ready = '1' then
                temp_out := signed(input_neuron) * signed(weight);
                output_reg <= STD_LOGIC_VECTOR(signed(current) + temp_out(31 DOWNTO 0));
                done_reg <= '1';         
            end if;     
        end if;
    end process;
    
    output <= output_reg;
    done <= done_reg;

end Behavioral;
