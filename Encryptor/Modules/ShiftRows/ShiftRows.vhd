library ieee;
use ieee.std_logic_1164.all;

entity ShiftRows is
  port (
    Clk    : in     std_logic;
    Enable : in     std_logic;
    Finish : out    std_logic;
    Rst    : in     std_logic;
    TxtIn  : in     std_logic_vector(127 downto 0);
    TxtOut : out    std_logic_vector(127 downto 0)
  );
end entity ShiftRows;

architecture rtl of ShiftRows is
    -- Arrays for 16 bytes
	 --type state_type is (St0, St1, St2);
	 --signal present_state, next_state : state_type;
    type byte_array is array (0 to 15) of std_logic_vector(7 downto 0);
    
    -- Internal signals
    signal input_bytes  : byte_array;
    signal output_bytes : byte_array;
    signal result       : std_logic_vector(127 downto 0);
    signal done         : std_logic := '0';
    signal enable_reg   : std_logic := '0';
begin

    -- Clock and reset process for control signals
    process(Clk, Rst)
    begin
        if Rst = '1' then
				--present_state <= St0;
            done <= '0';
            enable_reg <= '0';
        elsif rising_edge(Clk) then
            -- Register the enable signal
				--present_state <= next_state;
            enable_reg <= Enable;
            
            done <= '0';
            if enable_reg = '1' then
                done <= '1';
            end if;
        end if;
    end process;

    -- Input separation process (combinational)
    process (TxtIn)
    begin
        for i in 0 to 15 loop
            input_bytes(i) <= TxtIn(127 - i*8 downto 120 - i*8);
        end loop;
    end process;

    -- ShiftRows operation process (combinational)
    process (input_bytes)
    begin
        output_bytes(0)  <= input_bytes(0);
        output_bytes(4)  <= input_bytes(4);
        output_bytes(8)  <= input_bytes(8);
        output_bytes(12) <= input_bytes(12);

        output_bytes(1)  <= input_bytes(5);
        output_bytes(5)  <= input_bytes(9);
        output_bytes(9)  <= input_bytes(13);
        output_bytes(13) <= input_bytes(1);

        output_bytes(2)  <= input_bytes(10);
        output_bytes(6)  <= input_bytes(14);
        output_bytes(10) <= input_bytes(2);
        output_bytes(14) <= input_bytes(6);

        output_bytes(3)  <= input_bytes(15);
        output_bytes(7)  <= input_bytes(3);
        output_bytes(11) <= input_bytes(7);
        output_bytes(15) <= input_bytes(11);
    end process;

    -- Output reconstruction process (combinational)
    process (output_bytes)
    begin
        result <=
            output_bytes(0)  & output_bytes(1)  & output_bytes(2)  & output_bytes(3)  &
            output_bytes(4)  & output_bytes(5)  & output_bytes(6)  & output_bytes(7)  &
            output_bytes(8)  & output_bytes(9)  & output_bytes(10) & output_bytes(11) &
            output_bytes(12) & output_bytes(13) & output_bytes(14) & output_bytes(15);
    end process;

    -- Output assignments
    TxtOut <= result when done = '1' else (others => '0');
    Finish <= done;

end architecture rtl;
