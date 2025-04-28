-- Elmer Homero
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ShiftRows is
    Port ( 
				TxtIn 	: in  STD_LOGIC_VECTOR (127 downto 0);
				Enable 	: in  STD_LOGIC:='0';
				Clk 		: in  STD_LOGIC;
				Rst 		: in  STD_LOGIC;
				TxtOut 	: out  STD_LOGIC_VECTOR (127 downto 0);
				Finish 	: out  STD_LOGIC);
end ShiftRows;

architecture Behavioral of ShiftRows is
	
	signal txt: STD_logic_vector(127 downto 0);
   signal Flag: STD_LOGIC := '0';

begin
	process(Clk, Enable, Rst)
		begin
			if(Rst='1') then
				txt<= (others => '0');
			elsif(Enable='1' and rising_edge(Clk)) then
			
	--<--1	5			
					txt(7 downto 0)	<=TxtIn(39 downto 32);
	--<--2	10			
					txt(15 downto 8)	<=TxtIn(79 downto 72);
	--<--3	15			
					txt(23 downto 16)	<=TxtIn(119 downto 112);
	--<--4	4			
					txt(31 downto 24)	<=TxtIn(31 downto 24);
	--<--5	9			
					txt(39 downto 32)	<=TxtIn(71 downto 64);
	--<--6	14		
					txt(47 downto 40)	<=TxtIn(111 downto 104);
	--<--7	3		
					txt(55 downto 48)	<=TxtIn(23 downto 16);
	--<--8	8		
					txt(63 downto 56)	<=TxtIn(63 downto 56);
	--<--9	13		
					txt(71 downto 64)	<=TxtIn(103 downto 96);
	--<--10	2		
					txt(79 downto 72)	<=TxtIn(15 downto 8);
	--<--11	7		
					txt(87 downto 80)	<=TxtIn(55 downto 48);
	--<--12	12		
					txt(95 downto 88)	<=TxtIn(95 downto 88);
	--<--13	1		
					txt(103 downto 96)<=TxtIn(7 downto 0);
	--<--14	6		
					txt(111 downto 104)<=TxtIn(47 downto 40);
	--<--15	11		
					txt(119 downto 112)<=TxtIn(87 downto 80);
	--<--16	16		
					txt(127 downto 120)<=TxtIn(127 downto 120);
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
				if cta = "10" then --2do. clock
					Flag <= '1';
				end if;
			end if;
			if Flag = '1' then
				Flag<='0';
			end if;
		end if;
	end process;
		TxtOut(127 downto 0)<=txt(127 downto 0);			
		Finish <= Flag;

end Behavioral;














-- Angelo y equipo
--library ieee;
--use ieee.std_logic_1164.all;
--
--entity ShiftRows is
--  port (
--    Clk    : in     std_logic;
--    Enable : in     std_logic;
--    Finish : out    std_logic;
--    Rst    : in     std_logic;
--    TxtIn  : in     std_logic_vector(127 downto 0);
--    TxtOut : out    std_logic_vector(127 downto 0)
--  );
--end entity ShiftRows;
--
--architecture rtl of ShiftRows is
--    -- Arrays for 16 bytes
--	 type state_type is (St0, St1, St2);
--	 signal present_state, next_state : state_type;
--    type byte_array is array (0 to 15) of std_logic_vector(7 downto 0);
--    
--    -- Internal signals
--    signal input_bytes  : byte_array;
--    signal output_bytes : byte_array;
--    signal result       : std_logic_vector(127 downto 0) := (others => '0');
--	 signal result_reg   : std_logic_vector(127 downto 0) := (others => '0');
--    signal done         : std_logic := '0';
--    signal enable_reg   : std_logic := '0';
--begin
--
--    -- Clock and reset process for control signals
--    process(Clk, Rst)
--    begin
--        if Rst = '1' then
--				present_state <= St0;
--            done <= '0';
--            enable_reg <= '0';
--        elsif rising_edge(Clk) then
--            -- Register the enable signal
--				present_state <= next_state;
--            enable_reg <= Enable;
--				
--				case present_state is
--					when St0 =>
--						done <= '0';
--					when St1 =>
--						result_reg <= result;
--					when St2 =>
--						done <= '1';
--				end case;
--        end if;
--    end process;
--	 
--	 process(present_state, Enable)
--	 begin
--		next_state <= present_state;
--		
--		case present_state is 
--			when St0 =>
--				if Enable = '1' then
--					next_state <= St1;
--				end if;
--			when St1 =>
--				next_state <= St2;
--			when St2 =>
--				if Enable = '0' then
--					next_state <= St0;
--				end if;
--		end case;
--	end process;
--					
--
--    -- Input separation process (combinational)
--    process (TxtIn)
--    begin
--        for i in 0 to 15 loop
--            input_bytes(i) <= TxtIn(127 - i*8 downto 120 - i*8);
--        end loop;
--    end process;
--
--    -- ShiftRows operation process (combinational)
--    process (input_bytes)
--    begin
--        output_bytes(0)  <= input_bytes(0);
--        output_bytes(4)  <= input_bytes(4);
--        output_bytes(8)  <= input_bytes(8);
--        output_bytes(12) <= input_bytes(12);
--
--        output_bytes(1)  <= input_bytes(5);
--        output_bytes(5)  <= input_bytes(9);
--        output_bytes(9)  <= input_bytes(13);
--        output_bytes(13) <= input_bytes(1);
--
--        output_bytes(2)  <= input_bytes(10);
--        output_bytes(6)  <= input_bytes(14);
--        output_bytes(10) <= input_bytes(2);
--        output_bytes(14) <= input_bytes(6);
--
--        output_bytes(3)  <= input_bytes(15);
--        output_bytes(7)  <= input_bytes(3);
--        output_bytes(11) <= input_bytes(7);
--        output_bytes(15) <= input_bytes(11);
--    end process;
--
--    -- Output reconstruction process (combinational)
--    process (output_bytes)
--    begin
--        result <=
--            output_bytes(0)  & output_bytes(1)  & output_bytes(2)  & output_bytes(3)  &
--            output_bytes(4)  & output_bytes(5)  & output_bytes(6)  & output_bytes(7)  &
--            output_bytes(8)  & output_bytes(9)  & output_bytes(10) & output_bytes(11) &
--            output_bytes(12) & output_bytes(13) & output_bytes(14) & output_bytes(15);
--	 end process;
--
--    -- Output assignments
--    TxtOut <= result_reg;
--    Finish <= done;
--  end architecture rtl;

