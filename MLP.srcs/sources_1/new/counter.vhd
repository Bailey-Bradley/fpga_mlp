library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter is
    generic (
        COUNT_WIDTH : integer := 10
    );
    port (
        clk : in STD_LOGIC;
        en : in STD_LOGIC;
        inc : in STD_LOGIC;
        max_count : in STD_LOGIC_VECTOR(COUNT_WIDTH-1 downto 0);
        count_out : out STD_LOGIC_VECTOR(COUNT_WIDTH-1 downto 0);
        inc_out : out STD_LOGIC
    );
end counter;

architecture Behavioral of counter is
    signal count_reg : STD_LOGIC_VECTOR(COUNT_WIDTH-1 downto 0) := (others => '0');
begin

process(clk)
    variable count : STD_LOGIC_VECTOR(COUNT_WIDTH-1 downto 0) := (others => '0');
begin
    if rising_edge(clk) and en = '1' and inc = '1' then
        if count = max_count then
            count := (others => '0');
        else
            count := std_logic_vector(unsigned(count) + 1);
        end if;
        
        count_reg <= count;    
    end if;
    
    if count = max_count and inc = '1' then
        inc_out <= '1';
    else
        inc_out <= '0';
    end if;
    
end process;

    count_out <= count_reg;

end Behavioral;
