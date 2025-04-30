----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:08:58 05/12/2009 
-- Design Name: 
-- Module Name:    state_machine - Behavioral 
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


Entity StateMach is
    port(
      AddRoundu0En    : out    std_logic;
      AddRoundu0Fin   : in     std_logic;
      AddRoundu4En    : out    std_logic;
      AddRoundu4Fin   : in     std_logic;
      AddRoundu7En    : out    std_logic;
      AddRoundu7Fin   : in     std_logic;
      Clk             : in     std_logic;
      KeyEn           : out    std_logic;
      KeyFin          : in     std_logic;
      KeySel          : out    std_logic_vector(3 downto 0);
      MixColumnsu3En  : out    std_logic;
      MixColumnsu3Fin : in     std_logic;
      MuxSel          : out    std_logic;
      Rst             : in     std_logic;
      ShiftRowsu2En   : out    std_logic;
      ShiftRowsu2Fin  : in     std_logic;
      ShiftRowsu6En   : out    std_logic;
      ShiftRowsu6Fin  : in     std_logic;
      SubBytesu1En    : out    std_logic;
      SubBytesu1Fin   : in     std_logic;
      SubBytesu5En    : out    std_logic;
      SubBytesu5Fin   : in     std_logic);

  end StateMach;

architecture Behavioral of StateMach is

type ESTADOS is (KS, ARK1, SB1, SR1, MC, ARK2, SB2, SR2, ARK3, Fin); 

signal ESTACT, SIGEST: ESTADOS; 
signal s_SelectKey   : STD_LOGIC_VECTOR(3 downto 0);
signal Finish        : STD_LOGIC_VECTOR(8 downto 0); 
signal Enable        : STD_LOGIC_VECTOR(8 downto 0); 

-- ARK3 & SR2 & SB2 &ARK2 & MC & SR1 & SB1 & ARK1 & KS
--  b8    b7    b6    b5    b4    b3    b2    b1    b0    
   
	
begin

Finish <= AddRoundu7Fin & ShiftRowsu6Fin & SubBytesu5Fin & AddRoundu4Fin & MixColumnsu3Fin
          & ShiftRowsu2Fin & SubBytesu1Fin & AddRoundu0Fin & KeyFin;


	SIGUIENTE : process (Clk, Rst) 	
   begin 
        if (Rst = '1') then 
            ESTACT <= KS; 				
        elsif (rising_edge(Clk)) then 
            ESTACT <= SIGEST; 
        end if; 
    end process;                        --End REG_PROC 

    CUALSIG: process (ESTACT, Finish) 
    begin 
        case ESTACT is 
            when KS => 
					 s_SelectKey <= "0000";
					 Enable    <= "000000001"; 
				    if(Finish = "000000001") then
						SIGEST <= ARK1;
                end if;						
            when ARK1 => 
					 Enable    <= "000000010"; 
                MuxSel    <= '0';
				    if(Finish = "000000010") then
						SIGEST <= SB1;
                end if;						
            when SB1 => 
					 Enable    <= "000000100"; 
				    if(Finish = "000000100") then
						SIGEST <= SR1;
                end if;						
            when SR1 =>   
					 Enable    <= "000001000"; 
				    if(Finish = "000001000") then
						SIGEST <= MC;
                end if;						
				when MC => 
					 Enable    <= "000010000";					 
				    if(Finish = "000010000") then
					   s_SelectKey <= s_SelectKey + 1;
						SIGEST <= ARK2;
                end if;						
            when ARK2 => 
					 Enable    <= "000100000";  
                MuxSel    <= '1';
				    if(s_SelectKey = "1001" and Finish = "000100000") then
						SIGEST <= SB2;
					 elsif(Finish = "000100000") then
						SIGEST <= SB1;
                end if;						
            when SB2 => 
					 Enable    <= "001000000";  
				    if(Finish = "001000000") then
						SIGEST <= SR2;
                end if;						
            when SR2 => 
					 Enable    <= "010000000"; 
				    if(Finish = "010000000") then
						SIGEST <= ARK3;
                end if;						
            when ARK3 => 
					 Enable    <= "100000000";
 					 s_SelectKey <= "1010"; 					 
				    if(Finish = "100000000") then
						SIGEST <= Fin;
						s_SelectKey <= "0000"; 
                end if;
	         when Fin => 
					 Enable      <= "000000000";
					 SIGEST      <= Fin;
 					 s_SelectKey <= "0000"; 					 
        end case; 
	end process;

	KeySel <= s_SelectKey;
	
   KeyEn          <= Enable(0);
   AddRoundu0En	<= Enable(1);
   SubBytesu1En	<= Enable(2);
   ShiftRowsu2En	<= Enable(3);
   MixColumnsu3En <= Enable(4);
   AddRoundu4En	<= Enable(5);
   SubBytesu5En   <= Enable(6);
   ShiftRowsu6En  <= Enable(7);
   AddRoundu7En   <= Enable(8);
	
end Behavioral;


