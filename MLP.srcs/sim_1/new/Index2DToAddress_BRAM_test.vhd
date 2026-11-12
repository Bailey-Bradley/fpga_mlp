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

entity Index2DToAddress_BRAM_test is
--  Port ( );
end Index2DToAddress_BRAM_test;

architecture Behavioral of Index2DToAddress_BRAM_test is
    signal clk : STD_LOGIC;
    signal en : STD_LOGIC;
    signal row_index : STD_LOGIC_VECTOR(5 downto 0);
    signal column_index : STD_LOGIC_VECTOR(9 downto 0);
    signal row_width : STD_LOGIC_VECTOR(9 downto 0);
    signal address_offset : STD_LOGIC_VECTOR(15 downto 0);
    signal address : STD_LOGIC_VECTOR(15 downto 0);
    
    signal wea: STD_LOGIC;
    signal dina : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal douta : STD_LOGIC_VECTOR(7 DOWNTO 0);
    
begin

indexer : entity work.Index2DToAddress
    port map(
        clk => clk,
        en => en,
        row_index => row_index,
        column_index => column_index,
        row_width => row_width,
        address_offset => address_offset,
        address => address
    );
    
bram : entity xil_defaultlib.weights_mem
    port map (
        clka => clk,
        ena => en,
        wea => wea,
        addra => address,
        dina => dina,
        douta => douta
    );
    
process begin
    en <= '1';
    row_index <= "001001";
    column_index <= "0000111111";
    row_width <= "0001000000";
    address_offset <= "1100010000000000";
    
    wea <= '0';
    dina <= "00000000";
    
    for i in 1 to 6 loop
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
    end loop;
    
    assert(douta="00011111") report "Failed 1" severity error;
    
    wait;
end process;

end Behavioral;
