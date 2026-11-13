library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library xil_defaultlib;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    port(
        clk: in std_logic;
        go: in std_logic
    );
end top;

architecture Behavioral of top is
    signal state_reg: std_logic_vector(1 downto 0) := "00";
    
    signal index2dtoaddress_en: std_logic;
    signal counter_en: std_logic;
    signal weights_en: std_logic;
    signal input_mem_en: std_logic;
    
    signal counter10_max_count: std_logic_vector(9 downto 0);
    signal counter6_max_count: std_logic_vector(5 downto 0);
    signal neuron_write_finished: std_logic := '1';
    signal counter10_inc_out: std_logic;
    signal neuron_src_index: std_logic_vector(9 downto 0);
    signal neuron_dst_index: std_logic_vector(5 downto 0);
    signal row_width: std_logic_vector(9 downto 0);
    signal address_offset: std_logic_vector(15 downto 0);
    signal weight_address: std_logic_vector(15 downto 0);
    signal counter6_inc_out: std_logic;
    signal image_data: std_logic;
    signal weight_data: std_logic_vector(7 downto 0);
    
    signal sw0: std_logic;
    signal sw1: std_logic;
    signal sw2: std_logic;
    signal sw3: std_logic;
begin

index2d_to_address : entity work.Index2DToAddress
port map(
    clk => clk,
    en => index2dtoaddress_en,
    row_index => neuron_dst_index,
    column_index => neuron_src_index,
    row_width => row_width,
    address_offset => address_offset,
    address => weight_address
);

counter10 : entity work.counter
generic map (
    COUNT_WIDTH => 10
)
port map(
    clk => clk,
    en => counter_en,
    inc => neuron_write_finished,
    max_count => counter10_max_count,
    count_out => neuron_src_index,
    inc_out => counter10_inc_out
);
    
counter6 : entity work.counter
generic map (
    COUNT_WIDTH => 6
)
port map(
    clk => clk,
    en => counter_en,
    inc => counter10_inc_out,
    max_count => counter6_max_count,
    count_out => neuron_dst_index,
    inc_out => counter6_inc_out
);

weights_mem : entity xil_defaultlib.weights_mem
port map (
    clka => clk,
    ena => weights_en,
    wea => std_logic'('0'),
    addra => weight_address,
    dina => "00000000",
    douta => weight_data
);
    
image_reader : entity work.image_reader
port map (
    clk => clk,
    en => input_mem_en,
    addr => neuron_src_index,
    dout => image_data,
    
    sw0 => sw0,
    sw1 => sw1,
    sw2 => sw2,
    sw3 => sw3
);
    
process(clk) begin
    
    if rising_edge(clk) then
        case state_reg is
            when "00" =>
                if go = '1' then
                    state_reg <= "01";
                end if;
            when "01" =>
                if counter6_inc_out = '1' then
                    state_reg <= "10";
                end if;
            when "10" =>
                if counter6_inc_out = '1' then
                    state_reg <= "11";
                end if;
            when "11" =>
                if counter6_inc_out = '1' then
                    state_reg <= "00";
                end if;
            when others =>
                
        end case;
    end if;
    
end process;

    index2dtoaddress_en <= '1' when state_reg = "01" or state_reg = "10" else '0';
    
    counter_en <= '0' when state_reg = "00" else '1';
    
    counter10_max_count <= "0000000000" when state_reg = "00" else
                        B"11_0000_1111" when state_reg = "01" else
                        B"00_0100_0000" when state_reg = "10" else
                        B"00_0000_1010" when state_reg = "11" else "0000000000";
                        
    counter6_max_count <= "000000" when state_reg = "00" else
                          "111111" when state_reg = "01" else
                          "001010" when state_reg = "10" else
                          "000000" when state_reg = "11" else "000000";
                          
    row_width <= counter10_max_count; -- DOES THIS CAUSE 1 CYCLE DELAY BETWEEN COUNTER10_MAX_COUNT AND ROW_WIDTH??????
    
    address_offset <= "0000000000000000" when state_reg = "00" else
                      "0000000000000000" when state_reg = "01" else
                      B"1100_0110_1000_0000" when state_reg = "10" else
                      "0000000000000000" when state_reg = "11" else "0000000000000000";
                      
    weights_en <= '1' when state_reg = "01" or state_reg = "10" else '0';
    
    input_mem_en <= '1' when state_reg = "01" else '0';

end Behavioral;
