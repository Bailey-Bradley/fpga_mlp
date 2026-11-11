library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library xil_defaultlib;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bram_test is
end bram_test;



architecture Behavioral of bram_test is
    signal clka : STD_LOGIC;
    signal ena: STD_LOGIC;
    signal wea: STD_LOGIC;
    signal addra: STD_LOGIC_VECTOR(15 downto 0);
    signal dina : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal douta : STD_LOGIC_VECTOR(7 DOWNTO 0);
begin
DUT : entity xil_defaultlib.blk_mem_gen_0
  PORT MAP (
    clka => clka,
    ena => ena,
    wea => wea,
    addra => addra,
    dina => dina,
    douta => douta
    );
    
process begin
    
    ena <= '1';
    wea <= '0';
    addra <= "0000000000000000";
    dina <= "00000000";
    
    clka <= '0';
    wait for 1 ns;
    clka <= '1';
    wait for 1 ns;
    
    addra <= "0000000000000010";
    
    clka <= '0';
    wait for 1 ns;
    clka <= '1';
    wait for 1 ns;
    clka <= '0';
    wait for 1 ns;
    clka <= '1';
    wait for 1 ns;
    clka <= '0';
    wait for 1 ns;
    clka <= '1';
    wait for 1 ns;

end process;
    

end Behavioral;
