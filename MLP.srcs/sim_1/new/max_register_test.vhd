----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2026 07:13:58 PM
-- Design Name: 
-- Module Name: max_register_test - Behavioral
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

entity max_register_test is
--  Port ( );
end max_register_test;

architecture Behavioral of max_register_test is
    signal en : STD_LOGIC := '0';
    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '0'; -- assert any time you want to perform a new inference
    signal input_val : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    signal input_idx : STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
    signal output_value : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    signal output_idx : STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
begin

    DUT : entity work.max_register
        port map (
            en => en,
            clk => clk,
            rst => rst,
            input_val => input_val,
            input_idx => input_idx,
            output_value => output_value,
            output_idx => output_idx
        );
        
    process begin
        input_val <= x"0000FFFF";
        input_idx <= "0110";
        en <= '1';
        
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
        
        assert output_value = x"0000FFFF" report "Failed Value-Test-1" severity error;
        assert output_idx = "0110" report "Failed Index-Test-1" severity error;
        
        input_val <= x"000000FF";
        input_idx <= "0111";
        
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
        
        assert output_value = x"0000FFFF" report "Failed Value-Test-2" severity error;
        assert output_idx = "0110" report "Failed Index-Test-2" severity error;
        
        input_val <= x"00FFFFFF";
        input_idx <= "0001";
        
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
        
        assert output_value = x"00FFFFFF" report "Failed Value-Test-3" severity error;
        assert output_idx = "0001" report "Failed Index-Test-3" severity error;
        
        rst <= '1';
        
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
        
        assert output_value = x"80000000" report "Failed Value-Test-4" severity error;
        assert output_idx = "0000" report "Failed Index-Test-4" severity error;
        
        rst <= '0';
        input_val <= x"00000001";
        input_idx <= "0011";
        
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
        
        assert output_value = x"00000001" report "Failed Value-Test-5" severity error;
        assert output_idx = "0011" report "Failed Index-Test-5" severity error;
        
        input_val <= x"8000FFFF";
        input_idx <= "0101";
        
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
        
        assert output_value = x"00000001" report "Failed Value-Test-6" severity error;
        assert output_idx = "0011" report "Failed Index-Test-6" severity error;
        
        input_val <= x"00000001"; -- this is a test on being the same value as whats stored to see if the index doesnt change
        input_idx <= "0111"; -- see, its a different index
        
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
        
        assert output_value = x"00000001" report "Failed Value-Test-7" severity error;
        assert output_idx = "0011" report "Failed Index-Test-7" severity error;
        
        report "max register tests done" severity note;
    
    wait;    
    end process;

end Behavioral;
