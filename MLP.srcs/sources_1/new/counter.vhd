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
        inc_out : out STD_LOGIC;
        done : out STD_LOGIC := '0'
    );
end counter;

architecture Behavioral of counter is
    signal count_reg : STD_LOGIC_VECTOR(COUNT_WIDTH-1 downto 0) := (others => '0');
    signal prev_en : STD_LOGIC := '0';
begin

process(clk)
begin
    if rising_edge(clk) then
        
        prev_en <= en;
    
        if en = '1' and inc = '1' then
            if unsigned(count_reg) = unsigned(max_count) - 1 then
                count_reg <= (others => '0');
            else
                count_reg <= std_logic_vector(unsigned(count_reg) + 1);
            end if;
        end if;
        
        if (en and inc) = '1' or (not prev_en and en) = '1' then
            done <= '1';
        else
            done <= '0';
        end if;

    end if;
end process;

    inc_out <= '1' when (en = '1') and (inc = '1') and (unsigned(count_reg) = unsigned(max_count) - 1) else '0';
    count_out <= count_reg;

end Behavioral;
