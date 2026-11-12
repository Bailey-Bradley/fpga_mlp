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
DUT : entity xil_defaultlib.weights_mem
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
    addra <= "0000000000000001";
    dina <= "00000000";
    
    for i in 1 to 3 loop
        clka <= '0';
        wait for 1 ns;
        clka <= '1';
        wait for 1 ns;
    end loop;
    
    assert(douta="00000010") report "Failed 1" severity error;
    
    addra <= "0000000000000010";
    
    for i in 1 to 3 loop
        clka <= '0';
        wait for 1 ns;
        clka <= '1';
        wait for 1 ns;
    end loop;
    
    assert(douta="11111101") report "Failed 2" severity error;
    
    addra <= "0000000000000100";
    
    for i in 1 to 3 loop
        clka <= '0';
        wait for 1 ns;
        clka <= '1';
        wait for 1 ns;
    end loop;
    
    assert(douta="11111111") report "Failed 3" severity error;
    
    wait;

end process;
    

end Behavioral;
