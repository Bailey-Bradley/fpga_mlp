library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library xil_defaultlib;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity weights_mem_addresser is
    port (
        clk : in STD_LOGIC;
        en : in STD_LOGIC;
        column_index : in STD_LOGIC_VECTOR(9 downto 0);
        row_index : in STD_LOGIC_VECTOR(6 downto 0);
        row_width : in STD_LOGIC_VECTOR(9 downto 0);
        address_offset : in STD_LOGIC_VECTOR(16 downto 0);
        dout : out STD_LOGIC_VECTOR(7 downto 0);
        
        ready : in STD_LOGIC;
        done : out STD_LOGIC
    );
end weights_mem_addresser;

architecture Behavioral of weights_mem_addresser is
    signal weights_address : STD_LOGIC_VECTOR(16 downto 0);
    
    signal done_delay : STD_LOGIC_VECTOR(2 downto 0) := "000";
begin

weights_mem : entity xil_defaultlib.weights_mem
    PORT MAP (
        clka => clk,
        ena => en,
        wea => STD_LOGIC'('0'),
        addra => weights_address(15 downto 0),
        dina => "00000000",
        douta => dout
    );
    
indexer : entity work.Index2DToAddress
    port map(
        clk => clk,
        en => en,
        row_index => row_index,
        column_index => column_index,
        row_width => row_width,
        address_offset => address_offset,
        address => weights_address
    );
    
    done <= '1' when done_delay = "101" else '0';
    
process(clk) begin
    if rising_edge(clk) then
        if done_delay = "000" then
            if ready = '1' then
                done_delay <= "001";
            end if;
        elsif done_delay = "101" then
            done_delay <= "000";
        else
            done_delay <= STD_LOGIC_VECTOR(unsigned(done_delay) + 1);
        end if;
    end if;
end process;

end Behavioral;
