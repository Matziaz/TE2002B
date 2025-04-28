-- Elmer Homero
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:12:44 05/02/2009 
-- Design Name: 
-- Module Name:    SubBytes - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
--
------ Uncomment the following library declaration if instantiating
------ any Xilinx primitives in this code.
----library UNISIM;
----use UNISIM.VComponents.all;
--
--entity InvSubBytes is
--    Port ( TxtIn 	: in  	STD_LOGIC_VECTOR (127 downto 0);
--			  Clk			: in		STD_LOGIC;
--			  Enable			: in		STD_LOGIC;
--			  Rst			: in		STD_LOGIC;
--           TxtOut 	: out  	STD_LOGIC_VECTOR (127 downto 0);
--			  Finish		: out		STD_LOGIC := '0');
--end InvSubBytes;
--
--architecture Behavioral of InvSubBytes is
--signal Flag: STD_LOGIC := '0';
--
--component SBox
--port(
--	Addr		: in	STD_LOGIC_VECTOR(7 downto 0);
--	DataOut	: out	STD_LOGIC_VECTOR(7 downto 0));
--end component;
--
--component Mux
--port(
--	A		: in	STD_LOGIC_VECTOR(127 downto 0);
--	Sel	: in	STD_LOGIC_VECTOR(4 downto 0);
--	B		: out	STD_LOGIC_VECTOR(7 downto 0));
--end component;
--
--component DeMux
--port(
--	A		: in	STD_LOGIC_VECTOR(7 downto 0);
--	Sel	: in	STD_LOGIC_VECTOR(4 downto 0);
--	B		: out	STD_LOGIC_VECTOR(127 downto 0));
--end component;
--
----signal declaration
--signal i0		: std_logic_vector(7 downto 0);
--signal o0		: std_logic_vector(7 downto 0);
--signal temp		: std_logic_vector(4 downto 0) := "00000";
--signal temp2	: std_logic := '0';
--
--begin
--
--C01: Mux
--port map(
--	A	 	=> TxtIn(127 downto 0),
--	Sel	=> temp,
--	B		=> i0);
--
--C02: SBox
--port map(
--	Addr		=> i0,
--	DataOut	=> o0);
--
--C03: DeMux
--port map(
--	A		=> o0,
--	Sel	=> temp,
--	B		=> TxtOut(127 downto 0));
--	
----process(Clk,Enable,Rst)
----begin
----	if(Enable = '0' OR Rst = '1') then
----		temp <= "00000";
----	elsif(rising_edge(Clk)) then
----		if(temp2 = '1') then
----			Finish <= '1';
----			temp2 <= '0';
----		else
----			Finish <= '0';
----		end if;
----	elsif(rising_edge(Clk)) then
----		temp <= temp + 1;
----		if(temp = "10000")then
----			temp2 <= '1';
----		end if;
----	end if;
----end process;
--
--
--process(Rst,Clk,Enable)
--    
----	variable cta : STD_LOGIC_VECTOR (1 downto 0):="00000";
--	begin
--		if Rst = '1' then
--			temp <= "00000";
--		elsif rising_edge(Clk) then
--			if Enable = '1' then
--				temp <= temp + 1;
--				if temp = "10000" then --2do. clock
--					Flag <= '1';
--				end if;
--			end if;
--			if Flag = '1' then
--				Flag<='0';
--			end if;
--		end if;
--
--	end process;
--Finish <= Flag;
--
--
--end Behavioral;



















-- Samatha y Equipo
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InvSubBytes is
    port (
        Clk    : in  std_logic;
        Enable : in  std_logic;
        Finish : out std_logic;
        Rst    : in  std_logic;
        TxtIn  : in  std_logic_vector(127 downto 0);
        TxtOut : out std_logic_vector(127 downto 0)
    );
end entity InvSubBytes;

architecture behavioral of InvSubBytes is
    -- State machine states
    type state_type is (IDLE, PROCESSING, DONE);
    signal current_state, next_state : state_type;
    
    -- Internal registers
    signal data_reg : std_logic_vector(127 downto 0);
    signal result_reg : std_logic_vector(127 downto 0);
    signal byte_counter : integer range 0 to 16;
    
    -- Inverse S-Box LUT (Inverse SubBytes transformation table)
    type sbox_array is array (0 to 255) of std_logic_vector(7 downto 0);
    constant INV_SBOX : sbox_array := (
        -- Row 0
        x"52", x"09", x"6a", x"d5", x"30", x"36", x"a5", x"38", x"bf", x"40", x"a3", x"9e", x"81", x"f3", x"d7", x"fb",
        -- Row 1
        x"7c", x"e3", x"39", x"82", x"9b", x"2f", x"ff", x"87", x"34", x"8e", x"43", x"44", x"c4", x"de", x"e9", x"cb",
        -- Row 2
        x"54", x"7b", x"94", x"32", x"a6", x"c2", x"23", x"3d", x"ee", x"4c", x"95", x"0b", x"42", x"fa", x"c3", x"4e",
        -- Row 3
        x"08", x"2e", x"a1", x"66", x"28", x"d9", x"24", x"b2", x"76", x"5b", x"a2", x"49", x"6d", x"8b", x"d1", x"25",
        -- Row 4
        x"72", x"f8", x"f6", x"64", x"86", x"68", x"98", x"16", x"d4", x"a4", x"5c", x"cc", x"5d", x"65", x"b6", x"92",
        -- Row 5
        x"6c", x"70", x"48", x"50", x"fd", x"ed", x"b9", x"da", x"5e", x"15", x"46", x"57", x"a7", x"8d", x"9d", x"84",
        -- Row 6
        x"90", x"d8", x"ab", x"00", x"8c", x"bc", x"d3", x"0a", x"f7", x"e4", x"58", x"05", x"b8", x"b3", x"45", x"06",
        -- Row 7
        x"d0", x"2c", x"1e", x"8f", x"ca", x"3f", x"0f", x"02", x"c1", x"af", x"bd", x"03", x"01", x"13", x"8a", x"6b",
        -- Row 8
        x"3a", x"91", x"11", x"41", x"4f", x"67", x"dc", x"ea", x"97", x"f2", x"cf", x"ce", x"f0", x"b4", x"e6", x"73",
        -- Row 9
        x"96", x"ac", x"74", x"22", x"e7", x"ad", x"35", x"85", x"e2", x"f9", x"37", x"e8", x"1c", x"75", x"df", x"6e",
        -- Row A
        x"47", x"f1", x"1a", x"71", x"1d", x"29", x"c5", x"89", x"6f", x"b7", x"62", x"0e", x"aa", x"18", x"be", x"1b",
        -- Row B
        x"fc", x"56", x"3e", x"4b", x"c6", x"d2", x"79", x"20", x"9a", x"db", x"c0", x"fe", x"78", x"cd", x"5a", x"f4",
        -- Row C
        x"1f", x"dd", x"a8", x"33", x"88", x"07", x"c7", x"31", x"b1", x"12", x"10", x"59", x"27", x"80", x"ec", x"5f",
        -- Row D
        x"60", x"51", x"7f", x"a9", x"19", x"b5", x"4a", x"0d", x"2d", x"e5", x"7a", x"9f", x"93", x"c9", x"9c", x"ef",
        -- Row E
        x"a0", x"e0", x"3b", x"4d", x"ae", x"2a", x"f5", x"b0", x"c8", x"eb", x"bb", x"3c", x"83", x"53", x"99", x"61",
        -- Row F
        x"17", x"2b", x"04", x"7e", x"ba", x"77", x"d6", x"26", x"e1", x"69", x"14", x"63", x"55", x"21", x"0c", x"7d"
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
                        -- AES state is processed in column-major order
                        -- But for simplicity, we'll process bytes linearly from MSB to LSB
                        -- Each byte is mapped through the inverse S-box
                        result_reg(127 - 8*byte_counter downto 120 - 8*byte_counter) <= 
                            INV_SBOX(to_integer(unsigned(data_reg(127 - 8*byte_counter downto 120 - 8*byte_counter))));
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

