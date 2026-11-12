library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity chained_counter_test is
end chained_counter_test;

architecture Behavioral of chained_counter_test is
    signal clk: STD_LOGIC;
    signal en: STD_LOGIC;
    signal inc: STD_LOGIC;
    signal max_count1: STD_LOGIC_VECTOR(9 downto 0);
    signal max_count2: STD_LOGIC_VECTOR(5 downto 0);
    signal count_out1: STD_LOGIC_VECTOR(9 downto 0);
    signal count_out2: STD_LOGIC_VECTOR(5 downto 0);
    signal inc_out1: STD_LOGIC;
    signal inc_out2: STD_LOGIC;
begin

counter1 : entity work.counter
    generic map (
        COUNT_WIDTH => 10
    )
    port map(
        clk => clk,
        en => en,
        inc => inc,
        max_count => max_count1,
        count_out => count_out1,
        inc_out => inc_out1
    );
    
counter2 : entity work.counter
    generic map (
        COUNT_WIDTH => 6
    )
    port map(
        clk => clk,
        en => en,
        inc => inc_out1,
        max_count => max_count2,
        count_out => count_out2,
        inc_out => inc_out2
    );
    
process begin
    clk <= '0';
    en <= '1';
    inc <= '1';
    
    max_count1 <= "0000001010";
    max_count2 <= "000101";
    
    wait for 1 ns;
    
    for i in 0 to 9 loop
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
    end loop;
    
    assert(count_out1="0000001010") report "Failed 1" severity error;
    assert(count_out2="000000") report "Failed 2" severity error;
    
    inc <= '0';
    
    for i in 0 to 2 loop
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
    end loop;
    
    assert(count_out1="0000001010") report "Failed 3" severity error;
    assert(count_out2="000000") report "Failed 4" severity error;
    
    inc <= '1';
    
    for i in 0 to 5 loop
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
    end loop;
    
    assert(count_out1="0000000101") report "Failed 5" severity error;
    assert(count_out2="000001") report "Failed 6" severity error;
    
    wait;
end process;

end Behavioral;
