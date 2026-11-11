library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Index2DToAddress is
    generic (
        ROW_INDEX_WIDTH : integer := 6;
        COLUMN_INDEX_WIDTH: integer := 10;
        ROW_WIDTH_WIDTH: integer := 10;
        ADDRESS_OFFSET_WIDTH: integer := 16;
        ADDRESS_WIDTH: integer := 16
    );
    Port (
        clk : in STD_LOGIC;
        en : in STD_LOGIC;
        row_index : in STD_LOGIC_VECTOR(ROW_INDEX_WIDTH-1 downto 0);
        column_index : in STD_LOGIC_VECTOR(COLUMN_INDEX_WIDTH-1 downto 0);
        row_width : in STD_LOGIC_VECTOR(ROW_WIDTH_WIDTH-1 downto 0);
        address_offset : in STD_LOGIC_VECTOR(ADDRESS_OFFSET_WIDTH-1 downto 0);
        address : out STD_LOGIC_VECTOR(ADDRESS_WIDTH-1 downto 0)
     );
end Index2DToAddress;

architecture Behavioral of Index2DToAddress is
    signal mult_out: std_logic_vector(ROW_INDEX_WIDTH + ROW_WIDTH_WIDTH - 1 downto 0);
    signal adder_out: std_logic_vector(ROW_INDEX_WIDTH + ROW_WIDTH_WIDTH - 1 downto 0);
begin
    process(clk) begin
        if rising_edge(clk) and en = '1' then
            mult_out <= std_logic_vector(unsigned(row_index) * unsigned(row_width));
            adder_out <= std_logic_vector(unsigned(mult_out) + unsigned(column_index));
            address <= std_logic_vector(unsigned(adder_out) + unsigned(address_offset));
        end if;
    end process;
end Behavioral;
