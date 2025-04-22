----------------------------------------------------------------------------------
-- Company:		ITESM - IRS 2025
-- Author:           	Yumee Chung, Ana Coronel, Adrián Márquez, Andrés Zegales
-- Create Date: 	22/04/2025
-- Design Name: 	Mix Columns
-- Module Name:		Mix Columns Module
-- Target Devices: 	DE10-Lite
-- Description: 	Mix Columns AES - Module
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all; 

entity MixColumns is
  port (
    Clk    : in     std_logic;
    Enable : in     std_logic;
    Finish : out    std_logic;
    Rst    : in     std_logic;
    TxtIn  : in     std_logic_vector(127 downto 0);
    TxtOut : out    std_logic_vector(127 downto 0));
end entity MixColumns;

architecture rtl of MixColumns is

    -- Function Galois Multiplier 
	function Mult(NumA : STD_LOGIC_VECTOR; NumB : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
		type ROM is array (0 to 255) of STD_LOGIC_VECTOR(7 downto 0);
		constant ROM2 : ROM := (	x"00",x"02",x"04",x"06",x"08",x"0A",x"0C",x"0E",x"10",x"12",x"14",x"16",x"18",x"1A",x"1C",x"1E",
											x"20",x"22",x"24",x"26",x"28",x"2A",x"2C",x"2E",x"30",x"32",x"34",x"36",x"38",x"3A",x"3C",x"3E",
											x"40",x"42",x"44",x"46",x"48",x"4A",x"4C",x"4E",x"50",x"52",x"54",x"56",x"58",x"5A",x"5C",x"5E",
											x"60",x"62",x"64",x"66",x"68",x"6A",x"6C",x"6E",x"70",x"72",x"74",x"76",x"78",x"7A",x"7C",x"7E",
											x"80",x"82",x"84",x"86",x"88",x"8A",x"8C",x"8E",x"90",x"92",x"94",x"96",x"98",x"9A",x"9C",x"9E",
											x"A0",x"A2",x"A4",x"A6",x"A8",x"AA",x"AC",x"AE",x"B0",x"B2",x"B4",x"B6",x"B8",x"BA",x"BC",x"BE",
											x"C0",x"C2",x"C4",x"C6",x"C8",x"CA",x"CC",x"CE",x"D0",x"D2",x"D4",x"D6",x"D8",x"DA",x"DC",x"DE",
											x"E0",x"E2",x"E4",x"E6",x"E8",x"EA",x"EC",x"EE",x"F0",x"F2",x"F4",x"F6",x"F8",x"FA",x"FC",x"FE",
											x"1B",x"19",x"1F",x"1D",x"13",x"11",x"17",x"15",x"0B",x"09",x"0F",x"0D",x"03",x"01",x"07",x"05",
											x"3B",x"39",x"3F",x"3D",x"33",x"31",x"37",x"35",x"2B",x"29",x"2F",x"2D",x"23",x"21",x"27",x"25",
											x"5B",x"59",x"5F",x"5D",x"53",x"51",x"57",x"55",x"4B",x"49",x"4F",x"4D",x"43",x"41",x"47",x"45",
											x"7B",x"79",x"7F",x"7D",x"73",x"71",x"77",x"75",x"6B",x"69",x"6F",x"6D",x"63",x"61",x"67",x"65",
											x"9B",x"99",x"9F",x"9D",x"93",x"91",x"97",x"95",x"8B",x"89",x"8F",x"8D",x"83",x"81",x"87",x"85",
											x"BB",x"B9",x"BF",x"BD",x"B3",x"B1",x"B7",x"B5",x"AB",x"A9",x"AF",x"AD",x"A3",x"A1",x"A7",x"A5",
											x"DB",x"D9",x"DF",x"DD",x"D3",x"D1",x"D7",x"D5",x"CB",x"C9",x"CF",x"CD",x"C3",x"C1",x"C7",x"C5",
											x"FB",x"F9",x"FF",x"FD",x"F3",x"F1",x"F7",x"F5",x"EB",x"E9",x"EF",x"ED",x"E3",x"E1",x"E7",x"E5");
	
		constant ROM3 : ROM := (	x"00",x"03",x"06",x"05",x"0C",x"0F",x"0A",x"09",x"18",x"1B",x"1E",x"1D",x"14",x"17",x"12",x"11",
											x"30",x"33",x"36",x"35",x"3C",x"3F",x"3A",x"39",x"28",x"2B",x"2E",x"2D",x"24",x"27",x"22",x"21",
											x"60",x"63",x"66",x"65",x"6C",x"6F",x"6A",x"69",x"78",x"7B",x"7E",x"7D",x"74",x"77",x"72",x"71",
											x"50",x"53",x"56",x"55",x"5C",x"5F",x"5A",x"59",x"48",x"4B",x"4E",x"4D",x"44",x"47",x"42",x"41",
											x"C0",x"C3",x"C6",x"C5",x"CC",x"CF",x"CA",x"C9",x"D8",x"DB",x"DE",x"DD",x"D4",x"D7",x"D2",x"D1",
											x"F0",x"F3",x"F6",x"F5",x"FC",x"FF",x"FA",x"F9",x"E8",x"EB",x"EE",x"ED",x"E4",x"E7",x"E2",x"E1",
											x"A0",x"A3",x"A6",x"A5",x"AC",x"AF",x"AA",x"A9",x"B8",x"BB",x"BE",x"BD",x"B4",x"B7",x"B2",x"B1",
											x"90",x"93",x"96",x"95",x"9C",x"9F",x"9A",x"99",x"88",x"8B",x"8E",x"8D",x"84",x"87",x"82",x"81",
											x"9B",x"98",x"9D",x"9E",x"97",x"94",x"91",x"92",x"83",x"80",x"85",x"86",x"8F",x"8C",x"89",x"8A",
											x"AB",x"A8",x"AD",x"AE",x"A7",x"A4",x"A1",x"A2",x"B3",x"B0",x"B5",x"B6",x"BF",x"BC",x"B9",x"BA",
											x"FB",x"F8",x"FD",x"FE",x"F7",x"F4",x"F1",x"F2",x"E3",x"E0",x"E5",x"E6",x"EF",x"EC",x"E9",x"EA",
											x"CB",x"C8",x"CD",x"CE",x"C7",x"C4",x"C1",x"C2",x"D3",x"D0",x"D5",x"D6",x"DF",x"DC",x"D9",x"DA",
											x"5B",x"58",x"5D",x"5E",x"57",x"54",x"51",x"52",x"43",x"40",x"45",x"46",x"4F",x"4C",x"49",x"4A",
											x"6B",x"68",x"6D",x"6E",x"67",x"64",x"61",x"62",x"73",x"70",x"75",x"76",x"7F",x"7C",x"79",x"7A",
											x"3B",x"38",x"3D",x"3E",x"37",x"34",x"31",x"32",x"23",x"20",x"25",x"26",x"2F",x"2C",x"29",x"2A",
											x"0B",x"08",x"0D",x"0E",x"07",x"04",x"01",x"02",x"13",x"10",x"15",x"16",x"1F",x"1C",x"19",x"1A");
	begin 
		if (NumB = x"02") then
			return ROM2(to_integer(unsigned(NumA))); 
		elsif (NumB = x"03") then 
			return ROM3(to_integer(unsigned(NumA)));
		else 
			return x"00";
		end if; 	
   end Mult;
  
	 -- Function Galois Adder
	function Mix (PlainTxt : std_logic_vector) return std_logic_vector is 
		variable byte0  : std_logic_vector(7 downto 0) := PlainTxt(127 downto 120);
		variable byte1  : std_logic_vector(7 downto 0) := PlainTxt(119 downto 112);
		variable byte2  : std_logic_vector(7 downto 0) := PlainTxt(111 downto 104);
		variable byte3  : std_logic_vector(7 downto 0) := PlainTxt(103 downto 96);
		variable byte4  : std_logic_vector(7 downto 0) := PlainTxt (95 downto 88);
		variable byte5  : std_logic_vector(7 downto 0) := PlainTxt (87 downto 80);
		variable byte6  : std_logic_vector(7 downto 0) := PlainTxt (79 downto 72);
		variable byte7  : std_logic_vector(7 downto 0) := PlainTxt (71 downto 64);
		variable byte8  : std_logic_vector(7 downto 0) := PlainTxt (63 downto 56);
		variable byte9  : std_logic_vector(7 downto 0) := PlainTxt (55 downto 48);
		variable byte10 : std_logic_vector(7 downto 0) := PlainTxt (47 downto 40);
		variable byte11 : std_logic_vector(7 downto 0) := PlainTxt (39 downto 32);
		variable byte12 : std_logic_vector(7 downto 0) := PlainTxt (31 downto 24);
		variable byte13 : std_logic_vector(7 downto 0) := PlainTxt (23 downto 16);
		variable byte14 : std_logic_vector(7 downto 0) := PlainTxt (15 downto 8);
		variable byte15 : std_logic_vector(7 downto 0) := PlainTxt  (7 downto 0);
		variable CypherTxt : std_logic_vector(127 downto 0);
		begin
		-- First Colummn
		CypherTxt (127 downto 120) := Mult(byte0,x"02") XOR Mult(byte1,x"03") XOR byte2 XOR byte3; -- 02 03 01 01
		CypherTxt (119 downto 112) := byte0 XOR Mult(byte1,x"02") XOR Mult(byte2,x"03") XOR byte3; -- 01 02 03 01
		CypherTxt (111 downto 104) := byte0 XOR byte1 XOR Mult(byte2,x"02") XOR Mult(byte3,x"03"); -- 01 01 02 03
		CypherTxt (103 downto 96)  := Mult(byte0,x"03") XOR byte1 XOR byte2 XOR Mult(byte3,x"02"); -- 03 01 01 02
		-- Second Colummn
		CypherTxt (95 downto 88)   := Mult(byte4,x"02") XOR Mult(byte5,x"03") XOR byte6 XOR byte7; -- 02 03 01 01
		CypherTxt (87 downto 80)   := byte4 XOR Mult(byte5,x"02") XOR Mult(byte6,x"03") XOR byte7; -- 01 02 03 01
		CypherTxt (79 downto 72)   := byte4 XOR byte5 XOR Mult(byte6,x"02") XOR Mult(byte7,x"03"); -- 01 01 02 03
		CypherTxt (71 downto 64)   := Mult(byte4,x"03") XOR byte5 XOR byte6 XOR Mult(byte7,x"02"); -- 03 01 01 02
		-- Third Colummn
		CypherTxt (63 downto 56)   := Mult(byte8,x"02") XOR Mult(byte9,x"03") XOR byte10 XOR byte11; -- 02 03 01 01
		CypherTxt (55 downto 48)   := byte8 XOR Mult(byte9,x"02") XOR Mult(byte10,x"03") XOR byte11; -- 01 02 03 01
		CypherTxt (47 downto 40)   := byte8 XOR byte9 XOR Mult(byte10,x"02") XOR Mult(byte11,x"03"); -- 01 01 02 03
		CypherTxt (39 downto 32)   := Mult(byte8,x"03") XOR byte9 XOR byte10 XOR Mult(byte11,x"02"); -- 03 01 01 02
		-- Fourth Colummns
		CypherTxt (31 downto 24)   := Mult(byte12,x"02") XOR Mult(byte13,x"03") XOR byte14 XOR byte15; -- 02 03 01 01
		CypherTxt (23 downto 16)   := byte12 XOR Mult(byte13,x"02") XOR Mult(byte14,x"03") XOR byte15; -- 01 02 03 01
		CypherTxt (15 downto 8)    := byte12 XOR byte13 XOR Mult(byte14,x"02") XOR Mult(byte15,x"03"); -- 01 01 02 03
		CypherTxt (7 downto 0)     := Mult(byte12,x"03") XOR byte13 XOR byte14 XOR Mult(byte15,x"02"); -- 03 01 01 02
		return CypherTxt; 
	end Mix;
    
    -- Máquina de estados optimizada
	signal state_reg : STD_LOGIC_VECTOR (127 downto 0);  
	signal process_done: STD_LOGIC := '0';               
	 -- Define states for the state machine
   type state_type is (idle, processing, finished); 
   signal state : state_type := idle;                

	begin
    -- State machine to manage processing states
   process(Clk,Rst)
   begin
		if Rst = '1' then
			state <= idle;          
         state_reg <= (others => '0');
         process_done <= '0';
		elsif rising_edge(Clk) then
         case state is
				when idle =>
					if Enable = '1' then
						state <= processing;  
               end if;
            when processing =>
					state_reg <= Mix(TxtIn);  
               state <= finished;         
            when finished =>
               process_done <= '1';       
               if Enable = '0' then
						state <= idle;          
                  process_done <= '0';
               end if;
			end case;
		end if;
    end process;
    TxtOut <= state_reg;    
    Finish <= process_done; 
end architecture rtl ;
