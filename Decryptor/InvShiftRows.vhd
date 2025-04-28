--Elmer Homero
--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
--
--entity InvShiftRows is
--    Port ( 
--				TxtIn 	: in  STD_LOGIC_VECTOR (127 downto 0);
--				Enable 	: in  STD_LOGIC:='0';
--				Clk 		: in  STD_LOGIC;
--				Rst 		: in  STD_LOGIC;
--				TxtOut 	: out  STD_LOGIC_VECTOR (127 downto 0);
--				Finish 	: out  STD_LOGIC);
--end InvShiftRows;
--
--architecture Behavioral of InvShiftRows is
--	
--	signal txt: STD_logic_vector(127 downto 0);
--   signal Flag: STD_LOGIC := '0';
--
--begin
--	process(Clk, Enable, Rst)
--		begin
--			if(Rst='1') then
--				txt<= (others => '0');
--			elsif(Enable='1' and rising_edge(Clk)) then
--			
--	--<--1	13			
--					txt(7 downto 0)	<=TxtIn(103 downto 96);
--	--<--2	10			
--					txt(15 downto 8)	<=TxtIn(79 downto 72);
--	--<--3	7			
--					txt(23 downto 16)	<=TxtIn(55 downto 48);
--	--<--4	4			
--					txt(31 downto 24)	<=TxtIn(31 downto 24);
--	--<--5	1			
--					txt(39 downto 32)	<=TxtIn(7 downto 0);
--	--<--6	14		
--					txt(47 downto 40)	<=TxtIn(111 downto 104);
--	--<--7	11		
--					txt(55 downto 48)	<=TxtIn(87 downto 80);
--	--<--8	8		
--					txt(63 downto 56)	<=TxtIn(63 downto 56);
--	--<--9	5		
--					txt(71 downto 64)	<=TxtIn(39 downto 32);
--	--<--10	2		
--					txt(79 downto 72)	<=TxtIn(15 downto 8);
--	--<--11	15		
--					txt(87 downto 80)	<=TxtIn(119 downto 112);
--	--<--12	12		
--					txt(95 downto 88)	<=TxtIn(95 downto 88);
--	--<--13	9		
--					txt(103 downto 96)<=TxtIn(71 downto 64);
--	--<--14	6		
--					txt(111 downto 104)<=TxtIn(47 downto 40);
--	--<--15	3		
--					txt(119 downto 112)<=TxtIn(23 downto 16);
--	--<--16	16		
--					txt(127 downto 120)<=TxtIn(127 downto 120);
--			end if;
--	end process;
--	
--	process(Rst,Clk,Enable)
--    
--	variable cta : STD_LOGIC_VECTOR (1 downto 0):="00";
--	begin
--		if Rst = '1' then
--			cta := "00";
--		elsif rising_edge(Clk) then
--			if Enable = '1' then
--				cta := cta + 1;
--				if cta = "10" then --2do. clock
--					Flag <= '1';
--				end if;
--			end if;
--			if Flag = '1' then
--				Flag<='0';
--			end if;
--		end if;
--	end process;
--		TxtOut(127 downto 0)<=txt(127 downto 0);			
--		Finish <= Flag;
--
--end Behavioral;














-- Arturo Urías y Equipo
--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
--
--entity InvShiftRows is
--  port (
--    Clk    : in     std_logic;
--    Enable : in     std_logic;
--    Finish : out    std_logic;
--    Rst    : in     std_logic;
--    TxtIn  : in     std_logic_vector(127 downto 0);
--    TxtOut : out    std_logic_vector(127 downto 0)
--  );
--end entity InvShiftRows;
--
--architecture rtl of InvShiftRows is
--  -- Señales para el pipeline
--  signal row0, row1, row2, row3 : std_logic_vector(31 downto 0) := (others => '0');
--  signal rot1, rot2, rot3       : std_logic_vector(31 downto 0) := (others => '0');
--  signal output_reg             : std_logic_vector(127 downto 0) := (others => '0');
--  
--  -- Señales de control del pipeline
--  signal stage1_active : std_logic := '0';
--  signal stage2_active : std_logic := '0';
--  signal stage3_active : std_logic := '0';
--begin
--
--  process(Clk, Rst)
--  begin
--    if Rst = '1' then
--      -- Reset todas las señales
--      row0 <= (others => '0');
--      row1 <= (others => '0');
--      row2 <= (others => '0');
--      row3 <= (others => '0');
--      rot1 <= (others => '0');
--      rot2 <= (others => '0');
--      rot3 <= (others => '0');
--      output_reg <= (others => '0');
--      stage1_active <= '0';
--      stage2_active <= '0';
--      stage3_active <= '0';
--      Finish <= '0';
--      
--    elsif rising_edge(Clk) then
--      -- Pipeline Stage 1: Extracción de filas
--      if Enable = '1' then
--        row0 <= TxtIn(127 downto 120) & TxtIn(95 downto 88) & TxtIn(63 downto 56) & TxtIn(31 downto 24);
--        row1 <= TxtIn(119 downto 112) & TxtIn(87 downto 80) & TxtIn(55 downto 48) & TxtIn(23 downto 16);
--        row2 <= TxtIn(111 downto 104) & TxtIn(79 downto 72) & TxtIn(47 downto 40) & TxtIn(15 downto 8);
--        row3 <= TxtIn(103 downto 96)  & TxtIn(71 downto 64) & TxtIn(39 downto 32) & TxtIn(7 downto 0);
--        stage1_active <= '1';
--      else
--        stage1_active <= '0';
--      end if;
--      
--      -- Pipeline Stage 2: Cálculo de rotaciones
--      if stage1_active = '1' then
--        rot1 <= row1(7 downto 0) & row1(31 downto 8);      -- Rotación derecha 1 byte
--        rot2 <= row2(15 downto 0) & row2(31 downto 16);     -- Rotación derecha 2 bytes
--        rot3 <= row3(23 downto 0) & row3(31 downto 24);     -- Rotación derecha 3 bytes
--        stage2_active <= '1';
--      else
--        stage2_active <= '0';
--      end if;
--      
--      -- Pipeline Stage 3: Reconstrucción final
--      if stage2_active = '1' then
--        output_reg <= row0(31 downto 24) & rot1(31 downto 24) & rot2(31 downto 24) & rot3(31 downto 24) &
--							 row0(23 downto 16) & rot1(23 downto 16) & rot2(23 downto 16) & rot3(23 downto 16) &
--							 row0(15 downto 8)  & rot1(15 downto 8)  & rot2(15 downto 8)  & rot3(15 downto 8)  &
--							 row0(7 downto 0)   & rot1(7 downto 0)   & rot2(7 downto 0)   & rot3(7 downto 0);
--        stage3_active <= '1';
--      else
--        stage3_active <= '0';
--      end if;
--      
--      -- Señal Finish (activa durante 1 ciclo cuando el resultado está listo)
--      Finish <= stage3_active;
--    end if;
--  end process;
--
--  TxtOut <= output_reg;
--
--end architecture rtl;













-- Arturo Urías y Equipo, versión 2
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InvShiftRows is
  port (
    Clk    : in     std_logic;
    Enable : in     std_logic;
    Finish : out    std_logic;
    Rst    : in     std_logic;
    TxtIn  : in     std_logic_vector(127 downto 0);
    TxtOut : out    std_logic_vector(127 downto 0)
  );
end entity InvShiftRows;


architecture rtl of InvShiftRows is
  signal output_reg             : std_logic_vector(127 downto 0);
begin

  process(Clk, Rst)
  begin
    if Rst = '1' then
      output_reg <= (others => '0');
      Finish <= '0';

    elsif rising_edge(Clk) then
      if Enable = '1' then
        -- Reconstrucción
		 output_reg <= TxtIn(127 downto 120) & TxtIn(23 downto 16) & TxtIn(47 downto 40) & TxtIn(71 downto 64) &
							TxtIn(95 downto 88) & TxtIn(119 downto 112) & TxtIn(15 downto 8) & TxtIn(39 downto 32) &
							TxtIn(63 downto 56) & TxtIn(87 downto 80) & TxtIn(111 downto 104) & TxtIn(7 downto 0) &
							TxtIn(31 downto 24) & TxtIn(55 downto 48) & TxtIn(79 downto 72) & TxtIn(103 downto 96); 
		  
        Finish <= '1';
      else
        Finish <= '0';
      end if;
    end if;
  end process;

  TxtOut <= output_reg;

end architecture rtl;