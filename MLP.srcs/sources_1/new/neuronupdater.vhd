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


-- This is the module that actually takes an input neuron, applies ReLU, multiplies it by the weight, and updates the target output neuron.
entity neuronupdater is
    Port ( input_neuron : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           weight : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           current : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           output : out STD_LOGIC_VECTOR(31 DOWNTO 0));
end neuronupdater;

architecture Behavioral of neuronupdater is
begin
    process(input_neuron, weight, current)
        variable signed_in : signed(31 DOWNTO 0); -- i know i could just say signed(input_neuron) the entire time but
        variable relu_out : signed(31 DOWNTO 0); 
        variable weight_out : signed(39 DOWNTO 0); -- multiplying relu_out by the weight forces a 40 bit output so
    begin
        signed_in := signed(input_neuron);
    
        if signed_in(31) = '1' then
            relu_out := (others => '0');
        else
            relu_out := signed_in;
        end if;
        
        weight_out := relu_out * signed(weight);
        
        output <= STD_LOGIC_VECTOR(signed(current) + weight_out(31 DOWNTO 0));
    end process;

end Behavioral;
