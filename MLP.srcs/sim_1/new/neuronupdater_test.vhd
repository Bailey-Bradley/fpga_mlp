----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/14/2026 06:35:21 PM
-- Design Name: 
-- Module Name: neuronupdater_test - Behavioral
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

entity neuronupdater_test is
--  Port ( );
end neuronupdater_test;

architecture Behavioral of neuronupdater_test is
    signal clk : STD_LOGIC;
    signal en : STD_LOGIC;
    signal ready : STD_LOGIC;
    signal input_neuron : STD_LOGIC_VECTOR(31 downto 0) := (others => '0'); -- otherwise it gives me U for every bit
    signal weight : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal current : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal output: STD_LOGIC_VECTOR(31 downto 0);
    signal done : STD_LOGIC;
begin

    DUT : entity work.neuronupdater
        port map (
            clk => clk,
            en => en,
            ready => ready,
            input_neuron => input_neuron,
            weight => weight,
            current => current,
            output => output,
            done => done
        );
        
    process begin
        en <= '1';
        ready <= '0';
        
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
        
        assert done = '0' report "Failed Done-1" severity error;
        
        input_neuron(2 DOWNTO 0) <= "111"; -- input is 7
        weight <= "01000000"; -- weight is 64
        current(3 DOWNTO 0) <= "0100"; -- current output neuron is 4
        ready <= '1';
        
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
        
        assert signed(output) = 452 report "Failed Test-1" severity error;     
        assert done = '1' report "Failed Done-2" severity error;  
        ready <= '0';
        
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
        
        assert done = '0' report "Failed Done-3" severity error;  
        
        input_neuron(15 DOWNTO 0) <= "1101001011001010"; -- input is 53962
        -- the way im initializing these is silly but there will never be a leftover from a previous test due to equal/increasing ranges being used
        weight <= "01111111"; -- weight is 127
        current(7 DOWNTO 0) <= "11000100"; -- current output neuron is 196
        ready <= '1'; 
        
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
        
        assert signed(output) =  6853370 report "Failed Test-2" severity error;     
        ready <= '0';
        
        input_neuron(15 DOWNTO 0) <= "1101001011001010"; -- input is 53962
        weight <= "10000001"; -- weight is now -127
        current(7 DOWNTO 0) <= "11000100"; -- current output neuron is 196
        ready <= '1';
        
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
        
        assert signed(output) =   -6852978 report "Failed Test-3" severity error;     
        ready <= '0';
        
        report "neuron updater tests done" severity note;
        
    wait;    
    end process;

end Behavioral;
