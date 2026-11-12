library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Index2DToAddress_test is
--  Port ( );
end Index2DToAddress_test;

architecture Behavioral of Index2DToAddress_test is
    signal clk : STD_LOGIC;
    signal en : STD_LOGIC;
    signal row_index : STD_LOGIC_VECTOR(5 downto 0);
    signal column_index : STD_LOGIC_VECTOR(9 downto 0);
    signal row_width : STD_LOGIC_VECTOR(9 downto 0);
    signal address_offset : STD_LOGIC_VECTOR(15 downto 0);
    signal address : STD_LOGIC_VECTOR(15 downto 0);
    
begin

DUT : entity work.Index2DToAddress
    port map(
        clk => clk,
        en => en,
        row_index => row_index,
        column_index => column_index,
        row_width => row_width,
        address_offset => address_offset,
        address => address
    );
    
process begin
    en <= '0';
    row_index <= "000000";
    column_index <= "0000000000";
    row_width <= "0000000100";
    address_offset <= "0000000000100000";
    
    for i in 1 to 6 loop
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
    end loop;
    
    assert(address="UUUUUUUUUUUUUUUU") report "Failed 1" severity error;
    
    en <= '1';
    row_index <= "000101";
    column_index <= "0000000011";
    row_width <= "0000000100";
    address_offset <= "0000000000000100";
    
    for i in 1 to 3 loop
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
    end loop;
    
    assert(address="0000000000011011") report "Failed 2" severity error;
    
    row_index <= "111111";
    column_index <= "1100001111";
    row_width <= "1100010000";
    address_offset <= "0000000000000000";
    
    for i in 1 to 3 loop
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
    end loop;
    
    assert(address="1100001111111111") report "Failed 3" severity error;
    
    wait;
end process;

end Behavioral;
