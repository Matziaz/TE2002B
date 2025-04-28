-- Elmer Homero
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:08:56 05/04/2009 
-- Design Name: 
-- Module Name:    AddRoundKey - Behavioral 
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
--entity AddRoundKey is
--    Port ( TxtIn		  	: in  STD_LOGIC_VECTOR (127 downto 0);
--           KeyIn    		: in  STD_LOGIC_VECTOR (127 downto 0);
--           TxtOut		 	: out STD_LOGIC_VECTOR (127 downto 0);
--			  Enable      	: in  STD_LOGIC;
--			  Clk         	: in  STD_LOGIC;
--			  Rst			  	: in  STD_LOGIC;
--			  Finish      	: out STD_LOGIC:='0');
--end AddRoundKey;
--
--architecture Behavioral of AddRoundKey is
--
--	signal cipher : STD_LOGIC_VECTOR (127 downto 0);
--	signal round : STD_LOGIC_VECTOR (127 downto 0);
--	--signal finishe : STD_LOGIC:='0';
--	
--	type tipo_SRAM is ARRAY (0 to 15) of STD_LOGIC_VECTOR (7 downto 0);
--	signal memoria_cipher : tipo_SRAM;
--	signal memoria_key : tipo_SRAM;
----	signal flag : STD_LOGIC := '0';
--	signal Flag: STD_LOGIC := '0';
--begin
--	cipher <= TxtIn;
--	round <= KeyIn;
--	
----	--HACER LA Xor DIRECTO Y LA ASIGNACION TMB SIN SRAM
----	CipherKeyed (7 downto 0) <= 	CipherText (7 downto 0) xor RoundKey (7 downto 0);
----	CipherKeyed (15 downto 8) <= 	CipherText (15 downto 8) xor RoundKey (15 downto 8);
----	CipherKeyed (23 downto 16) <= CipherText (23 downto 16) xor RoundKey (23 downto 16);
----	CipherKeyed (31 downto 24) <= CipherText (31 downto 24) xor RoundKey (31 downto 24);
----	CipherKeyed (39 downto 32) <= CipherText (39 downto 32) xor RoundKey (39 downto 32);
----	CipherKeyed (47 downto 40) <= CipherText (47 downto 40) xor RoundKey (47 downto 40);
----	CipherKeyed (55 downto 48) <= CipherText (55 downto 48) xor RoundKey (55 downto 48);
----	CipherKeyed (63 downto 56) <= CipherText (63 downto 56) xor RoundKey (63 downto 56);
----	CipherKeyed (71 downto 64) <= CipherText (71 downto 64) xor RoundKey (71 downto 64);
----	CipherKeyed (79 downto 72) <= CipherText (79 downto 72) xor RoundKey (79 downto 72);
----	CipherKeyed (87 downto 80) <= CipherText (87 downto 90) xor RoundKey (87 downto 80);
----	CipherKeyed (95 downto 88) <= CipherText (95 downto 88) xor RoundKey (95 downto 88);
----	CipherKeyed (103 downto 96) <= CipherText (103 downto 96) xor RoundKey (103 downto 96);
----	CipherKeyed (111 downto 104) <= CipherText (111 downto 104) xor RoundKey (111 downto 104);
----	CipherKeyed (119 downto 112) <= CipherText (119 downto 112) xor RoundKey (119 downto 112);
----	CipherKeyed (127 downto 120) <= CipherText (127 downto 120) xor RoundKey (127 downto 120);
--	
--	process(Clk,Enable)
--	begin
--	if (rising_edge(Clk) and Enable = '1')then
--	memoria_cipher(0) <= cipher(7 downto 0);
--	memoria_cipher(1) <= cipher(15 downto 8);
--	memoria_cipher(2) <= cipher(23 downto 16);
--	memoria_cipher(3) <= cipher(31 downto 24);
--	memoria_cipher(4) <= cipher(39 downto 32);
--	memoria_cipher(5) <= cipher(47 downto 40);
--	memoria_cipher(6) <= cipher(55 downto 48);
--	memoria_cipher(7) <= cipher(63 downto 56);
--	memoria_cipher(8) <= cipher(71 downto 64);
--	memoria_cipher(9) <= cipher(79 downto 72);
--	memoria_cipher(10) <= cipher(87 downto 80);
--	memoria_cipher(11) <= cipher(95 downto 88);
--	memoria_cipher(12) <= cipher(103 downto 96);
--	memoria_cipher(13) <= cipher(111 downto 104);
--	memoria_cipher(14) <= cipher(119 downto 112);
--	memoria_cipher(15) <= cipher(127 downto 120);
--	
--	memoria_key(0) <= round(7 downto 0);
--	memoria_key(1) <= round(15 downto 8);
--	memoria_key(2) <= round(23 downto 16);
--	memoria_key(3) <= round(31 downto 24);
--	memoria_key(4) <= round(39 downto 32);
--	memoria_key(5) <= round(47 downto 40);
--	memoria_key(6) <= round(55 downto 48);
--	memoria_key(7) <= round(63 downto 56);
--	memoria_key(8) <= round(71 downto 64);
--	memoria_key(9) <= round(79 downto 72);
--	memoria_key(10) <= round(87 downto 80);
--	memoria_key(11) <= round(95 downto 88);
--	memoria_key(12) <= round(103 downto 96);
--	memoria_key(13) <= round(111 downto 104);
--	memoria_key(14) <= round(119 downto 112);
--	memoria_key(15) <= round(127 downto 120);
--
--	TxtOut (7 downto 0)  <= memoria_cipher(0) xor memoria_key(0);
--	TxtOut (15 downto 8) <= 	memoria_cipher(1) xor memoria_key(1);
--	TxtOut (23 downto 16) <= memoria_cipher(2) xor memoria_key(2);
--	TxtOut (31 downto 24) <= memoria_cipher(3) xor memoria_key(3);
--	TxtOut (39 downto 32) <= memoria_cipher(4) xor memoria_key(4);
--	TxtOut (47 downto 40) <= memoria_cipher(5) xor memoria_key(5);
--	TxtOut (55 downto 48) <= memoria_cipher(6) xor memoria_key(6);
--	TxtOut (63 downto 56) <= memoria_cipher(7) xor memoria_key(7);
--	TxtOut (71 downto 64) <= memoria_cipher(8) xor memoria_key(8);
--	TxtOut (79 downto 72) <= memoria_cipher(9) xor memoria_key(9);
--	TxtOut (87 downto 80) <= memoria_cipher(10) xor memoria_key(10);
--	TxtOut (95 downto 88) <= memoria_cipher(11) xor memoria_key(11);
--	TxtOut (103 downto 96) <= memoria_cipher(12) xor memoria_key(12);
--	TxtOut (111 downto 104) <= memoria_cipher(13) xor memoria_key(13);
--	TxtOut (119 downto 112) <= memoria_cipher(14) xor memoria_key(14);
--	TxtOut (127 downto 120) <= memoria_cipher(15) xor memoria_key(15);
--	end if;
--
--end process;	
--
--process(Rst,Clk,Enable)
--    
--	variable cta : STD_LOGIC_VECTOR (1 downto 0):="00";
--	begin
--		if Rst = '1' then
--			cta := "00";
--		elsif rising_edge(Clk) then
--			if Enable = '1' then
--				cta := cta + 1;
--				if cta = "11" then --2do. clock
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
--
--end Behavioral;
----



-- Obiel y equipo
-- Funciona
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AddRoundKey is
    Port ( TxtIn		  	: in  STD_LOGIC_VECTOR (127 downto 0);
           KeyIn    		: in  STD_LOGIC_VECTOR (127 downto 0);
           TxtOut		 	: out STD_LOGIC_VECTOR (127 downto 0);
			  Enable      	: in  STD_LOGIC;
			  Clk         	: in  STD_LOGIC;
			  Rst			  	: in  STD_LOGIC;
			  Finish      	: out STD_LOGIC:='0');
end AddRoundKey;

architecture Behavioral of AddRoundKey is

	signal cipher : STD_LOGIC_VECTOR (127 downto 0);
	signal round : STD_LOGIC_VECTOR (127 downto 0);
	--signal finishe : STD_LOGIC:='0';
	
	type tipo_SRAM is ARRAY (0 to 15) of STD_LOGIC_VECTOR (7 downto 0);
	signal memoria_cipher : tipo_SRAM;
	signal memoria_key : tipo_SRAM;
--	signal flag : STD_LOGIC := '0';
	signal Flag: STD_LOGIC := '0';
begin
	cipher <= TxtIn;
	round <= KeyIn;
	
	process(Clk,Enable)
	begin
	if (rising_edge(Clk) and Enable = '1')then
   memoria_cipher(0) <= cipher(7 downto 0);
	memoria_cipher(1) <= cipher(15 downto 8);
	memoria_cipher(2) <= cipher(23 downto 16);
	memoria_cipher(3) <= cipher(31 downto 24);
	memoria_cipher(4) <= cipher(39 downto 32);
	memoria_cipher(5) <= cipher(47 downto 40);
	memoria_cipher(6) <= cipher(55 downto 48);
	memoria_cipher(7) <= cipher(63 downto 56);
	memoria_cipher(8) <= cipher(71 downto 64);
	memoria_cipher(9) <= cipher(79 downto 72);
	memoria_cipher(10) <= cipher(87 downto 80);
	memoria_cipher(11) <= cipher(95 downto 88);
	memoria_cipher(12) <= cipher(103 downto 96);
	memoria_cipher(13) <= cipher(111 downto 104);
	memoria_cipher(14) <= cipher(119 downto 112);
	memoria_cipher(15) <= cipher(127 downto 120);
	
	memoria_key(0) <= round(7 downto 0);
	memoria_key(1) <= round(15 downto 8);
	memoria_key(2) <= round(23 downto 16);
	memoria_key(3) <= round(31 downto 24);
	memoria_key(4) <= round(39 downto 32);
	memoria_key(5) <= round(47 downto 40);
	memoria_key(6) <= round(55 downto 48);
	memoria_key(7) <= round(63 downto 56);
	memoria_key(8) <= round(71 downto 64);
	memoria_key(9) <= round(79 downto 72);
	memoria_key(10) <= round(87 downto 80);
	memoria_key(11) <= round(95 downto 88);
	memoria_key(12) <= round(103 downto 96);
	memoria_key(13) <= round(111 downto 104);
	memoria_key(14) <= round(119 downto 112);
	memoria_key(15) <= round(127 downto 120);

	TxtOut (7 downto 0)  <= memoria_cipher(0) xor memoria_key(0);
	TxtOut (15 downto 8) <= memoria_cipher(1) xor memoria_key(1);
	TxtOut (23 downto 16) <= memoria_cipher(2) xor memoria_key(2);
	TxtOut (31 downto 24) <= memoria_cipher(3) xor memoria_key(3);
	TxtOut (39 downto 32) <= memoria_cipher(4) xor memoria_key(4);
	TxtOut (47 downto 40) <= memoria_cipher(5) xor memoria_key(5);
	TxtOut (55 downto 48) <= memoria_cipher(6) xor memoria_key(6);
	TxtOut (63 downto 56) <= memoria_cipher(7) xor memoria_key(7);
	TxtOut (71 downto 64) <= memoria_cipher(8) xor memoria_key(8);
	TxtOut (79 downto 72) <= memoria_cipher(9) xor memoria_key(9);
	TxtOut (87 downto 80) <= memoria_cipher(10) xor memoria_key(10);
	TxtOut (95 downto 88) <= memoria_cipher(11) xor memoria_key(11);
	TxtOut (103 downto 96) <= memoria_cipher(12) xor memoria_key(12);
	TxtOut (111 downto 104) <= memoria_cipher(13) xor memoria_key(13);
	TxtOut (119 downto 112) <= memoria_cipher(14) xor memoria_key(14);
	TxtOut (127 downto 120) <= memoria_cipher(15) xor memoria_key(15);   
	end if;

end process;	

process(Rst,Clk,Enable)
    
	variable cta : STD_LOGIC_VECTOR (1 downto 0):="00";
	begin
		if Rst = '1' then
			cta := "00";
		elsif rising_edge(Clk) then
			if Enable = '1' then
				cta := cta + 1;
				if cta = "11" then --2do. clock
					Flag <= '1';
				end if;
			end if;
			if Flag = '1' then
				Flag<='0';
			end if;
		end if;

	end process;
Finish <= Flag;



end Behavioral;
