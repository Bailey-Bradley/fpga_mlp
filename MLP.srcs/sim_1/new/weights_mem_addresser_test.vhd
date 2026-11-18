library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity weights_mem_addresser_test is
--  Port ( );
end weights_mem_addresser_test;

architecture Behavioral of weights_mem_addresser_test is
    signal clk : std_logic;
    signal en : std_logic;
    signal column_index : std_logic_vector(9 downto 0);
    signal row_index : std_logic_vector(5 downto 0);
    signal row_width : std_logic_vector(9 downto 0);
    signal address_offset : std_logic_vector(15 downto 0);
    signal dout : std_logic_vector(7 downto 0);
    signal ready : std_logic;
    signal done : std_logic;
begin

weights_mem_addresser : entity work.weights_mem_addresser
port map (
    clk => clk,
    en => en,
    column_index => column_index,
    row_index => row_index,
    row_width => row_width,
    address_offset => address_offset,
    dout => dout,
    
    ready => ready,
    done => done
);

process begin
    en <= '1';
    address_offset <= "1100010000000000";
    column_index <= "0000111111";
    row_index <= "001001";
    row_width <= B"00_0100_0000";
    ready <= '1';
    
    clk <= '0';
    wait for 1 ns;
    clk <= '1';
    wait for 1 ns;
    
    ready <= '0';
    
    for i in 1 to 10 loop
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
    end loop;
    
    wait;
    
end process;

end Behavioral;
