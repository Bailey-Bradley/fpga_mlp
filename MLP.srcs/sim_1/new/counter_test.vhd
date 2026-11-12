library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter_test is
end counter_test;

architecture Behavioral of counter_test is
    signal clk: STD_LOGIC;
    signal en: STD_LOGIC;
    signal inc: STD_LOGIC;
    signal max_count: STD_LOGIC_VECTOR(9 downto 0);
    signal count_out: STD_LOGIC_VECTOR(9 downto 0);
    signal inc_out: STD_LOGIC;
begin

DUT : entity work.counter
    generic map (
        COUNT_WIDTH => 10
    )
    port map(
        clk => clk,
        en => en,
        inc => inc,
        max_count => max_count,
        count_out => count_out,
        inc_out => inc_out
    );
    
process begin
    clk <= '0';
    en <= '1';
    inc <= '0';
    max_count <= "0000001010";
    wait for 1 ns;
    
    for i in 1 to 2 loop
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
    end loop;
    
    assert(count_out=B"00_0000_0000") report "Failed 1" severity error;
    
    inc <= '1';
    
    for i in 1 to 2 loop
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
    end loop;
    
    assert(count_out=B"00_0000_0010") report "Failed 2" severity error;
    
    inc <= '0';
    
    for i in 1 to 2 loop
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
    end loop;
    
    assert(count_out=B"00_0000_0010") report "Failed 3" severity error;
    
    inc <= '1';
    
    for i in 1 to 8 loop
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
    end loop;
    
    assert(count_out=B"00_0000_1010") report "Failed 4" severity error;
    assert(inc_out='1') report "Failed 5" severity error;
    
    inc <= '0';
    
    clk <= '0';
    wait for 1 ns;
    clk <= '1';
    wait for 1 ns;
    
    assert(count_out=B"00_0000_1010") report "Failed 5" severity error;
    assert(inc_out='0') report "Failed 6" severity error;
    
    inc <= '1';
    
    clk <= '0';
    wait for 1 ns;
    clk <= '1';
    wait for 1 ns;
    
    assert(count_out=B"00_0000_0000") report "Failed 7" severity error;
    assert(inc_out='0') report "Failed 8" severity error;
    
    --assert(count_out="0000000000") report "Fail 1/1" severity error;
    
    wait;
end process;

end Behavioral;
