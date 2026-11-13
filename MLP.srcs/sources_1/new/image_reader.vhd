library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library xil_defaultlib;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity image_reader is
    port (
        clk : in STD_LOGIC;
        en : in STD_LOGIC;
        addr : in STD_LOGIC_VECTOR(9 downto 0);
        dout : out STD_LOGIC;
        
        sw0 : in STD_LOGIC;
        sw1 : in STD_LOGIC;
        sw2 : in STD_LOGIC;
        sw3 : in STD_LOGIC
    );
end image_reader;

architecture Behavioral of image_reader is
    signal addr_reg : STD_LOGIC_VECTOR(13 downto 0);
    signal switch_vector : STD_LOGIC_VECTOR(3 downto 0);
begin

input_mem : entity xil_defaultlib.input_mem
port map (
    clka => clk,
    ena => en,
    wea => std_logic'('0'),
    addra => addr_reg,
    dina => std_logic'('0'),
    douta => dout
);

switch_vector <= sw3 & sw2 & sw1 & sw0;

process(clk)
begin
    if rising_edge(clk) then
        addr_reg <= STD_LOGIC_VECTOR(resize(resize(unsigned(addr), 14) + resize(unsigned(switch_vector), 14) * 784, 14));
    end if;
end process;

end Behavioral;
