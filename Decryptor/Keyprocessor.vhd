----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:31:12 05/03/2009 
-- Design Name: 
-- Module Name:    Keyprocessor - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Keyprocessor is
	port(
			Clk	    : in  STD_LOGIC;
			Rst       : in  STD_LOGIC;
			Enable    : in  STD_LOGIC;
			KeyIn     : in  STD_LOGIC_VECTOR (127 downto 0);
			Rcon_data : in  STD_LOGIC_VECTOR (31 downto 0);
			SubR	    : in  STD_LOGIC_VECTOR (31 downto 0);
			WE			 : out STD_LOGIC;
			Finish    : out STD_LOGIC;
			Data_out  : out STD_LOGIC_VECTOR (127 downto 0);
			ColW		 : out STD_LOGIC_VECTOR (3 downto 0);
			Rcon_dir  : out STD_LOGIC_VECTOR (3 downto 0);
			SubW		 : out STD_LOGIC_VECTOR (31 downto 0));
end Keyprocessor;

architecture Behavioral of Keyprocessor is

		signal ktemp    : STD_LOGIC_VECTOR (31 downto 0);
		signal ktemp2   : STD_LOGIC_VECTOR (31 downto 0);
		signal ktemp3   : STD_LOGIC_VECTOR (31 downto 0);
		signal ktemp4   : STD_LOGIC_VECTOR (31 downto 0);
		signal ktemp5   : STD_LOGIC_VECTOR (31 downto 0);
		signal ktemp6   : STD_LOGIC_VECTOR (31 downto 0);
		signal ktemp7   : STD_LOGIC_VECTOR (31 downto 0);
		signal ktemp8   : STD_LOGIC_VECTOR (31 downto 0);
		signal ktemp9   : STD_LOGIC_VECTOR (31 downto 0);
		signal rtemp    : STD_LOGIC_VECTOR (31 downto 0);

begin

		process (Clk,Rst,Enable)
		variable step   : natural range 0 to 9  := 0;
		variable k		 : natural range 1 to 12 := 1;	         --Number of Round Key being calculated
		begin
			if (Rst = '1') then
				step := 0;
				k    := 1;
			elsif (Enable = '1') then
				if (rising_edge(Clk)) then
					if (k < 11) then
						if (step = 0) then								 		--CipherKey read and store
							Finish   <= '0';
							WE       <= '1';
							ColW     <= conv_std_logic_vector(0,4);		--Stored in register 0
							Data_out <= KeyIn;
							ktemp    <= KeyIn(31 downto 0);					--ktemp: RotWord and SubBytes					
							ktemp3   <= KeyIn(127 downto 96);			   --ktemp3: to be used in XOR
							ktemp4   <= KeyIn(95 downto 64);
							ktemp5   <= KeyIn(63 downto 32);
							step := step + 1;
						elsif (step = 1) then									--RotWord
							WE     <= '0';
							ktemp2 <= ktemp(23 downto 0) & ktemp(31 downto 24);
							step := step + 1;
						elsif (step = 2) then									--SubBytes
							SubW   <= ktemp2;
							step := step + 1;
						elsif (step = 3) then									--SubBytes result, Rcon	direction				
							ktemp2   <= SubR;										--ktemp2: SubBytes result
							Rcon_dir <= conv_std_logic_vector(k-1,4);		--Rcon direction
							step := step + 1;
						elsif (step = 4) then
							rtemp    <= Rcon_data;								--Rcon read					
							step := step + 1;
						elsif (step = 5) then									--XOR
							ktemp6   <= ktemp3 XOR ktemp2 XOR rtemp;
							step := step + 1;
						elsif (step = 6) then
							ktemp7   <= ktemp6 XOR ktemp4;
							step := step + 1;
						elsif (step = 7) then
							ktemp8   <= ktemp7 XOR ktemp5;
							step := step + 1;
						elsif (step = 8) then
							ktemp9   <= ktemp8 XOR ktemp;
							step := step + 1;
						elsif (step = 9) then									--Store key
							WE <= '1';
							ColW <= conv_std_logic_vector(k,4);
							Data_out <= ktemp6 & ktemp7 & ktemp8 & ktemp9;
							ktemp3 <= ktemp6;										--Rearrangement of variables
							ktemp4 <= ktemp7;
							ktemp5 <= ktemp8;
							ktemp  <= ktemp9;
							step := 1;
							k := k + 1;
						end if;
					elsif (k = 11) then  										--k=11, all keys calculated, send Finish pulse
							k := k + 1;
							Finish <= '1';
					elsif (k = 12) then  										--k=12, Finish signal set to '0' after 1 clock period
							Finish <= '0';
					end if;
				end if;
			end if;
		end process;

end Behavioral;

