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
        go: in std_logic;
        
        sw0: in std_logic;
        sw1: in std_logic;
        sw2: in std_logic;
        sw3: in std_logic
    );
end top;

architecture Behavioral of top is
    signal state_reg: std_logic_vector(1 downto 0) := "00";
    
    signal weights_mem_addresser_en: std_logic;
    signal counter_en: std_logic;
    signal weights_en: std_logic;
    signal input_mem_en: std_logic;
    signal neuron_updater_en: std_logic;
    signal hidden_layer_ram_en: std_logic;
    signal output_layer_ram_en: std_logic;
    signal max_register_en: std_logic;
    signal clock_splitter_en: std_logic;
    
    signal hidden_layer_ram_addr: std_logic_vector(5 downto 0);
    signal output_layer_ram_addr: std_logic_vector(3 downto 0);
    signal output_layer_ram_dout: std_logic_vector(31 downto 0);
    signal hidden_layer_ram_dout: std_logic_vector(31 downto 0);
    
    signal hidden_layer_ram_wea: std_logic;
    signal output_layer_ram_wea: std_logic;
    
    signal relu_out: std_logic_vector(31 downto 0);
    
    signal counter10_max_count: std_logic_vector(9 downto 0);
    signal counter6_max_count: std_logic_vector(6 downto 0);
    signal counter10_inc_out: std_logic;
    signal counter6_inc_out: std_logic;
    signal clock_splitter_out: std_logic;
    
    signal neuron_src_index: std_logic_vector(9 downto 0);
    signal neuron_dst_index: std_logic_vector(6 downto 0);
    
    signal row_width: std_logic_vector(9 downto 0);
    signal address_offset: std_logic_vector(16 downto 0);
    
    signal image_data: std_logic;
    signal weight_data: std_logic_vector(7 downto 0);
    
    signal input_neuron_value: std_logic_vector(31 downto 0);
    signal current_neuron_value: std_logic_vector(31 downto 0);
    signal new_neuron_value: std_logic_vector(31 downto 0);
    
    signal counter10_done : std_logic;
    signal counter6_done : std_logic;
    signal weights_mem_addresser_done : std_logic;
    signal neuron_updater_done : std_logic;
    signal max_reg_index_out : std_logic_vector(3 downto 0);
    signal counter10_inc : std_logic;
begin

counter10 : entity work.counter
generic map (
    COUNT_WIDTH => 10
)
port map(
    clk => clk,
    en => counter_en,
    inc => counter10_inc,
    max_count => counter10_max_count,
    count_out => neuron_src_index,
    inc_out => counter10_inc_out,
    done => counter10_done
);
    
counter6 : entity work.counter
generic map (
    COUNT_WIDTH => 7
)
port map(
    clk => clk,
    en => counter_en,
    inc => counter10_inc_out,
    max_count => counter6_max_count,
    count_out => neuron_dst_index,
    inc_out => counter6_inc_out,
    done => counter6_done
);

clock_splitter : entity work.counter
generic map (
    COUNT_WIDTH => 2
)
port map(
    clk => clk,
    en => clock_splitter_en,
    inc => '1',
    max_count => "11",
    count_out => open,
    inc_out => clock_splitter_out,
    done => open
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

weights_mem_addresser : entity work.weights_mem_addresser
port map (
    clk => clk,
    en => weights_mem_addresser_en,
    column_index => neuron_src_index,
    row_index => neuron_dst_index,
    row_width => counter10_max_count,
    address_offset => address_offset,
    dout => weight_data,
    ready => counter10_done,
    done => weights_mem_addresser_done
);

neuron_updater : entity work.neuronupdater
port map ( 
    clk => clk,
    en => neuron_updater_en,
    ready => weights_mem_addresser_done,
    input_neuron => input_neuron_value,
    weight => weight_data,
    current => current_neuron_value,
    output => new_neuron_value,
    done => neuron_updater_done
);

hidden_layer_ram : entity xil_defaultlib.hidden_layer_ram
port map (
    clka => clk,
    ena => hidden_layer_ram_en,
    wea => hidden_layer_ram_wea,
    addra => hidden_layer_ram_addr,
    dina => new_neuron_value,
    douta => hidden_layer_ram_dout
);

output_layer_ram : entity xil_defaultlib.output_layer_ram
port map (
    clka => clk,
    ena => output_layer_ram_en,
    wea => output_layer_ram_wea,
    addra => output_layer_ram_addr,
    dina => new_neuron_value,
    douta => output_layer_ram_dout
);

relu : entity work.relu
generic map (
    WIDTH => 32
)
port map (
    input => hidden_layer_ram_dout,
    output => relu_out
);

max_register : entity work.max_register
port map (
    en => max_register_en,
    clk => clk,
    input_val => output_layer_ram_dout,
    input_idx => neuron_src_index(3 downto 0),
    output_value => open,
    output_idx => max_reg_index_out
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

    weights_mem_addresser_en <= '1' when state_reg = "01" or state_reg = "10" else '0';
    
    counter_en <= '0' when state_reg = "00" else '1';
    
    counter10_max_count <= "0000000000" when state_reg = "00" else
                        B"11_0001_0000" when state_reg = "01" else
                        B"00_0100_0000" when state_reg = "10" else
                        B"00_0000_1010" when state_reg = "11" else "0000000000";
                        
    counter6_max_count <= "0000000" when state_reg = "00" else
                          "1000000" when state_reg = "01" else
                          "0001010" when state_reg = "10" else
                          "0000001" when state_reg = "11" else "0000000";
                          
    address_offset <= "00000000000000000" when state_reg = "00" else
                      "00000000000000000" when state_reg = "01" else
                      B"0_1100_0100_0000_0000" when state_reg = "10" else
                      "00000000000000000" when state_reg = "11" else "00000000000000000";
                      
    weights_en <= '1' when state_reg = "01" or state_reg = "10" else '0';
    
    input_mem_en <= '1' when state_reg = "01" else '0';
    
    neuron_updater_en <= '1' when state_reg = "01" or state_reg = "10" else '0';
    
    hidden_layer_ram_en <= '1' when state_reg = "01" or state_reg = "10" else '0';
    
    hidden_layer_ram_addr <= neuron_dst_index(5 downto 0) when state_reg = "01" else neuron_src_index(5 downto 0) when state_reg = "10" else (others => '0');
    
    input_neuron_value <= (0 => image_data, others => '0') when state_reg = "01" else relu_out when state_reg = "10" else (others => '0');
    
    current_neuron_value <= hidden_layer_ram_dout when state_reg = "01" else output_layer_ram_dout when state_reg = "10" else (others => '0');
    
    output_layer_ram_en <= '1' when state_reg = "10" or state_reg = "11" else '0';
    
    output_layer_ram_addr <= neuron_dst_index(3 downto 0) when state_reg = "10" else neuron_src_index(3 downto 0) when state_reg = "11" else (others => '0');
    
    counter10_inc <= '0' when state_reg = "00" else neuron_updater_done when state_reg = "01" or state_reg = "10" else clock_splitter_out when state_reg = "11" else '0';
    
    max_register_en <= '1' when state_reg = "11" else '0';
    
    hidden_layer_ram_wea <= neuron_updater_done when state_reg = "01" else '0';
    
    output_layer_ram_wea <= neuron_updater_done when state_reg = "10" else '0';
    
    clock_splitter_en <= '1' when state_reg = "11" else '0';
end Behavioral;
