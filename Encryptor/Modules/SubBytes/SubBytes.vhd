----------------------------------------------------------------------------------
-- Company:		ITESM - IRS 2025
-- Author:           	Antonio Enguilo, Lizeth Niniz, Mariana Hernandez 
-- Create Date: 	22/04/2025
-- Design Name: 	Sub Bytes
-- Module Name:		Sub Bytes Module
-- Target Devices: 	DE10-Lite
-- Description: 	Sub Bytes AES - Module
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SubBytes is
    port (
        Clk    : in  std_logic;
        Enable : in  std_logic;
        Finish : out std_logic;
        Rst    : in  std_logic;
        TxtIn  : in  std_logic_vector(127 downto 0);
        TxtOut : out std_logic_vector(127 downto 0)
    );
end entity SubBytes;

architecture behavioral of SubBytes is
    -- State machine states
    type state_type is (IDLE, PROCESSING, DONE);
    signal current_state, next_state : state_type;
    
    -- Internal registers
    signal data_reg : std_logic_vector(127 downto 0);
    signal result_reg : std_logic_vector(127 downto 0);
    signal byte_counter : integer range 0 to 16;
    
    -- Forward S-Box LUT (SubBytes transformation table for encryption)
    type sbox_array is array (0 to 255) of std_logic_vector(7 downto 0);
    constant SBOX : sbox_array := (
        -- Row 0
        x"63", x"7c", x"77", x"7b", x"f2", x"6b", x"6f", x"c5", x"30", x"01", x"67", x"2b", x"fe", x"d7", x"ab", x"76",
        -- Row 1
        x"ca", x"82", x"c9", x"7d", x"fa", x"59", x"47", x"f0", x"ad", x"d4", x"a2", x"af", x"9c", x"a4", x"72", x"c0",
        -- Row 2
        x"b7", x"fd", x"93", x"26", x"36", x"3f", x"f7", x"cc", x"34", x"a5", x"e5", x"f1", x"71", x"d8", x"31", x"15",
        -- Row 3
        x"04", x"c7", x"23", x"c3", x"18", x"96", x"05", x"9a", x"07", x"12", x"80", x"e2", x"eb", x"27", x"b2", x"75",
        -- Row 4
        x"09", x"83", x"2c", x"1a", x"1b", x"6e", x"5a", x"a0", x"52", x"3b", x"d6", x"b3", x"29", x"e3", x"2f", x"84",
        -- Row 5
        x"53", x"d1", x"00", x"ed", x"20", x"fc", x"b1", x"5b", x"6a", x"cb", x"be", x"39", x"4a", x"4c", x"58", x"cf",
        -- Row 6
        x"d0", x"ef", x"aa", x"fb", x"43", x"4d", x"33", x"85", x"45", x"f9", x"02", x"7f", x"50", x"3c", x"9f", x"a8",
        -- Row 7
        x"51", x"a3", x"40", x"8f", x"92", x"9d", x"38", x"f5", x"bc", x"b6", x"da", x"21", x"10", x"ff", x"f3", x"d2",
        -- Row 8
        x"cd", x"0c", x"13", x"ec", x"5f", x"97", x"44", x"17", x"c4", x"a7", x"7e", x"3d", x"64", x"5d", x"19", x"73",
        -- Row 9
        x"60", x"81", x"4f", x"dc", x"22", x"2a", x"90", x"88", x"46", x"ee", x"b8", x"14", x"de", x"5e", x"0b", x"db",
        -- Row A
        x"e0", x"32", x"3a", x"0a", x"49", x"06", x"24", x"5c", x"c2", x"d3", x"ac", x"62", x"91", x"95", x"e4", x"79",
        -- Row B
        x"e7", x"c8", x"37", x"6d", x"8d", x"d5", x"4e", x"a9", x"6c", x"56", x"f4", x"ea", x"65", x"7a", x"ae", x"08",
        -- Row C
        x"ba", x"78", x"25", x"2e", x"1c", x"a6", x"b4", x"c6", x"e8", x"dd", x"74", x"1f", x"4b", x"bd", x"8b", x"8a",
        -- Row D
        x"70", x"3e", x"b5", x"66", x"48", x"03", x"f6", x"0e", x"61", x"35", x"57", x"b9", x"86", x"c1", x"1d", x"9e",
        -- Row E
        x"e1", x"f8", x"98", x"11", x"69", x"d9", x"8e", x"94", x"9b", x"1e", x"87", x"e9", x"ce", x"55", x"28", x"df",
        -- Row F
        x"8c", x"a1", x"89", x"0d", x"bf", x"e6", x"42", x"68", x"41", x"99", x"2d", x"0f", x"b0", x"54", x"bb", x"16"
    );

begin
    -- State register process
    process(Clk, Rst)
    begin
        if Rst = '1' then
            current_state <= IDLE;
            data_reg <= (others => '0');
            result_reg <= (others => '0');
            byte_counter <= 0;
        elsif rising_edge(Clk) then
            current_state <= next_state;
            
            case current_state is
                when IDLE =>
                    if Enable = '1' then
                        data_reg <= TxtIn;
                        byte_counter <= 0;
                    end if;
                
                when PROCESSING =>
                    -- Process one byte at a time
                    if byte_counter < 16 then
                        -- Extract byte index for current counter
                        -- Process bytes linearly from MSB to LSB
                        -- Each byte is mapped through the S-box
                        result_reg(127 - 8*byte_counter downto 120 - 8*byte_counter) <= 
                            SBOX(to_integer(unsigned(data_reg(127 - 8*byte_counter downto 120 - 8*byte_counter))));
                        byte_counter <= byte_counter + 1;
                    end if;
                
                when DONE =>
                    -- Hold the result until next Enable
                    null;
            end case;
        end if;
    end process;
    
    -- Next state logic
    process(current_state, Enable, byte_counter)
    begin
        next_state <= current_state;  -- Default: stay in current state
        
        case current_state is
            when IDLE =>
                if Enable = '1' then
                    next_state <= PROCESSING;
                end if;
            
            when PROCESSING =>
                if byte_counter = 16 then
                    next_state <= DONE;
                end if;
            
            when DONE =>
                if Enable = '0' then
                    next_state <= IDLE;
                end if;
        end case;
    end process;
    
    -- Output logic
    TxtOut <= result_reg;
    Finish <= '1' when current_state = DONE else '0';

end architecture behavioral;
