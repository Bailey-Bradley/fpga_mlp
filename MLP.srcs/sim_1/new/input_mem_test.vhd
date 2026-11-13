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

entity input_mem_test is
end input_mem_test;

architecture Behavioral of input_mem_test is
    signal clka : STD_LOGIC;
    signal ena: STD_LOGIC;
    signal wea: STD_LOGIC_VECTOR(0 downto 0);
    signal addra: STD_LOGIC_VECTOR(13 downto 0);
    signal dina : STD_LOGIC_VECTOR(0 downto 0);
    signal douta : STD_LOGIC_VECTOR(0 downto 0);
begin
DUT : entity xil_defaultlib.input_mem
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
    wea <= "0";
    addra <= B"00_0000_1100_1010";
    dina <= "0";
    
    for i in 1 to 3 loop
        clka <= '0';
        wait for 1 ns;
        clka <= '1';
        wait for 1 ns;
    end loop;
    
    assert(douta="0") report "Failed 1" severity error;
    
    addra <= B"00_0000_1100_1011";
    
    for i in 1 to 3 loop
        clka <= '0';
        wait for 1 ns;
        clka <= '1';
        wait for 1 ns;
    end loop;
    
    assert(douta="1") report "Failed 2" severity error;
    
    addra <= B"00_0111_0010_1011";
    
    for i in 1 to 3 loop
        clka <= '0';
        wait for 1 ns;
        clka <= '1';
        wait for 1 ns;
    end loop;
    
    assert(douta="1") report "Failed 3" severity error;
    
    addra <= B"00_0000_1100_1100";
    
    for i in 1 to 3 loop
        clka <= '0';
        wait for 1 ns;
        clka <= '1';
        wait for 1 ns;
    end loop;
    
    assert(douta="1") report "Failed 4" severity error;
    
    wait;

end process;
    

end Behavioral;
