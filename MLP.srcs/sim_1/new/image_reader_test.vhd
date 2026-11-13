library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity image_reader_test is
end image_reader_test;

architecture Behavioral of image_reader_test is
    signal clk : STD_LOGIC;
    signal en : STD_LOGIC;
    signal addr : STD_LOGIC_VECTOR(9 downto 0);
    
    signal sw0 : STD_LOGIC;
    signal sw1 : STD_LOGIC;
    signal sw2 : STD_LOGIC;
    signal sw3 : STD_LOGIC;
    
    signal dout : STD_LOGIC;
begin

image_reader : entity work.image_reader
port map (
    clk => clk,
    en => en,
    addr => addr,
    dout => dout,
    
    sw0 => sw0,
    sw1 => sw1,
    sw2 => sw2,
    sw3 => sw3
);

process begin
    en <= '1';
    addr <= "0000000000";
    sw0 <= '0';
    sw1 <= '0';
    sw2 <= '0';
    sw3 <= '0';
    
    clk <= '0';
    wait for 1 ns;
    clk <= '1';
    wait for 1 ns;
    
    addr <= B"00_0010_1010";
    
    for i in 1 to 3 loop
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
    end loop;
    
    assert(dout='0') report "Failed 1" severity error;
    
    addr <= B"00_1100_1100";
    
    for i in 1 to 3 loop
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
    end loop;
    
    assert(dout='1') report "Failed 2" severity error;
    
    addr <= B"10_0011_1001";
    
    sw0 <= '1';
    sw1 <= '0';
    sw2 <= '0';
    sw3 <= '0';
    
    for i in 1 to 3 loop
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
    end loop;
    
    assert(dout='1') report "Failed 3" severity error;
    
    addr <= B"10_0011_0111";
    
    for i in 1 to 3 loop
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
    end loop;
    
    assert(dout='0') report "Failed 4" severity error;
    
    wait;
    
end process;

end Behavioral;
