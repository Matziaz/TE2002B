----------------------------------------------------------------------------------
-- Company: 		 ITESM Campus Queretaro
-- Engineers:		 Eder Gomez, Vicente Noguez 
-- 
-- Create Date:    15:29:21 05/01/2009 
-- Design Name: 
-- Module Name:    RoundKey - Behavioral 
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

entity KeySchedule is
    Port ( Clk     : in   STD_LOGIC;
		     Rst     : in   STD_LOGIC;
			  Enable  : in   STD_LOGIC;
           Sel     : in   STD_LOGIC_VECTOR (3 downto 0);
           KeyIn   : in   STD_LOGIC_VECTOR (127 downto 0);
           Finish  : out  STD_LOGIC;
           KeyOut  : out  STD_LOGIC_VECTOR (127 downto 0));
end KeySchedule;

architecture Behavioral of KeySchedule is

	--Main round key generating unit
	component Keyprocessor
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
	end component;
	
	--Memory to read/write keys
	component Keymem
		port(
			ColW	    : in  STD_LOGIC_VECTOR (3 downto 0);		--4 bytes to select between 11 different keys
			DataIn	 : in  STD_LOGIC_VECTOR (127 downto 0);
			Clk		 : in  STD_LOGIC;
			WE			 : in  STD_LOGIC;
			ColR      : in  STD_LOGIC_VECTOR (3 downto 0);
			DataOut	 : out STD_LOGIC_VECTOR (127 downto 0));
	end component;
	
	--Rcon ROM
	component Rcon
		port(
			ColumnIn	: in  STD_LOGIC_VECTOR (3  downto 0);		--4 bytes to select between 10 different columns
			DataOut	: out STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	--SubBytes unit
	component SubBytesKey
		port(
			DataIn	: in  STD_LOGIC_VECTOR (31 downto 0);
			DataOut  : out STD_LOGIC_VECTOR (31 downto 0));	
	end component;

	signal we       : STD_LOGIC;
	signal colw     : STD_LOGIC_VECTOR (3 downto 0);
	signal rcondir  : STD_LOGIC_VECTOR (3 downto 0);
	signal rcondata : STD_LOGIC_VECTOR (31 downto 0);
	signal subw	    : STD_LOGIC_VECTOR (31 downto 0);
	signal subr     : STD_LOGIC_VECTOR (31 downto 0);
	signal dataw    : STD_LOGIC_VECTOR (127 downto 0);
	
begin

	U01 : Keyprocessor
	port map(
			Clk	    => Clk,
			Rst		 => Rst,
			Enable    => Enable,
			KeyIn     => KeyIn,
			Rcon_data => rcondata,
			SubR	    => subr,
			WE			 => we,
			Finish    => Finish,
			Data_out  => dataw,
			ColW		 => colw,
			Rcon_dir  => rcondir,
			SubW		 => subw);
	
	U02 : Keymem
	port map(
			ColW   	 => colw,
			DataIn	 => dataw,
			Clk		 => Clk,
			WE			 => we,
			ColR 		 => Sel,
			DataOut	 => KeyOut);
	
	U03 : Rcon
	port map(
			ColumnIn  => rcondir,		
			DataOut	 => rcondata);
	
	U04 : SubBytesKey
	port map(
			DataIn	 => subw,
			DataOut   => subr);	

end Behavioral;

























-- Equipo Anell y Equipo 
--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--use work.aes_pkg.all;
--
--entity KeySchedule is
--    Port (
--        clk      : in  STD_LOGIC;
--        Rst    : in  STD_LOGIC;
--        Enable    : in  STD_LOGIC;
--        keyin   : in  STD_LOGIC_VECTOR(127 downto 0);  -- Llave original (Sel 0)
--        Finish     : out STD_LOGIC;                        -- '1' cuando las 11 subllaves están listas
--        -- Puerto para leer las subllaves en orden inverso (Sel 10 → Sel 0)
--        Sel    : in  STD_LOGIC_VECTOR(3 downto 0);            -- Selección de ronda (0=Sel 10, 10=Sel 0)
--        keyout  : out STD_LOGIC_VECTOR(127 downto 0)    -- Subllave seleccionada
--    );
--end KeySchedule;
--
--architecture Behavioral of KeySchedule is
--    -- Almacena las 11 subllaves (Sel 0 → Sel 10)
--    type key_memory is array (0 to 10) of STD_LOGIC_VECTOR(127 downto 0);
--    signal subkeys : key_memory := (others => (others => '0'));
--    
--    -- Señales de control
--    signal keys_ready : STD_LOGIC := '0';
--	 
--	 signal selvecctor : INTEGER range 0 to 10;
--begin
--    selint <= to_integer(unsigned(Sel));
--	 
--    -- Proceso para generar las subllaves
--    process(clk, Rst)
--        variable temp : STD_LOGIC_VECTOR(31 downto 0);
--        variable idx : INTEGER range 0 to 43 := 0;
--    begin
--        if Rst = '1' then
--            subkeys <= (others => (others => '0'));
--            idx := 0;
--            keys_ready <= '0';
--        elsif rising_edge(clk) then
--            if Enable = '1' and keys_ready = '0' then
--                -- Paso 1: Generar todas las subllaves (Sel 0 → Sel 10)
--                if idx = 0 then
--                    -- Cargar la llave original (Sel 0)
--                    subkeys(0) <= keyin;
--                    idx := idx + 1;
--                elsif idx <= 43 then
--                    -- Generar las siguientes subllaves
--                    temp := subkeys((idx-1)/4)(31 downto 0);  -- Última palabra de la subllave anterior
--                    
--                    -- Aplicar RotWord + SubWord + Rcon cada 4 palabras
--                    if idx mod 4 = 0 then
--                        temp := SubWord(RotWord(temp)) xor Rcon(idx/4);
--                    end if;
--                    
--                    -- Calcular nueva palabra y almacenar
--                    temp := temp xor subkeys((idx-4)/4)(31 downto 0);
--                    subkeys(idx/4)((idx mod 4)*32 + 31 downto (idx mod 4)*32) <= temp;
--                    
--                    idx := idx + 1;
--                end if;
--                
--                -- Indicar que todas las subllaves están listas
--                if idx = 44 then
--                    keys_ready <= '1';
--                end if;
--            end if;
--        end if;
--    end process;
--
--    -- Paso 2: Acceso a las subllaves en orden inverso (Sel 10 → Sel 0)
--    keyout <= subkeys(10 - Sel);  -- Por ejemplo, Sel=0 devuelve subkeys[10] (Sel 10)
--    Finish <= keys_ready;              -- '1' cuando las 11 subllaves están listas
--end Behavioral;


























-- Anell y Equipo v1
--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--use work.aes_pkg.all;
--
--entity KeySchedule is
--    Port (
--        clk      : in  STD_LOGIC;
--        Rst    : in  STD_LOGIC;
--        Enable    : in  STD_LOGIC;
--        keyin   : in  STD_LOGIC_VECTOR(127 downto 0);  -- Llave original (Sel 0)
--        Finish     : out STD_LOGIC;                        -- '1' cuando las 11 subllaves están listas
--        -- Puerto para leer las subllaves en orden inverso (Sel 10 → Sel 0)
--        Sel    : in  STD_LOGIC_VECTOR(3 downto 0);            -- Selección de ronda (0=Sel 10, 10=Sel 0)
--        keyout  : out STD_LOGIC_VECTOR(127 downto 0)    -- Subllave seleccionada
--    );
--end KeySchedule;
--
--architecture Behavioral of KeySchedule is
--    -- Almacena las 11 subllaves (Sel 0 → Sel 10)
--    type key_memory is array (0 to 10) of STD_LOGIC_VECTOR(127 downto 0);
--    signal subkeys : key_memory := (others => (others => '0'));
--    
--    -- Señales de control
--    signal keys_ready : STD_LOGIC := '0';
--	 
--begin
--
--    -- Proceso para generar las subllaves
--    process(clk, Rst)
--        variable temp : STD_LOGIC_VECTOR(31 downto 0);
--        variable idx : INTEGER range 0 to 43 := 0;
--    begin
--        if Rst = '1' then
--            subkeys <= (others => (others => '0'));
--            idx := 0;
--            keys_ready <= '0';
--        elsif rising_edge(clk) then
--            if Enable = '1' and keys_ready = '0' then
--                -- Paso 1: Generar todas las subllaves (Sel 0 → Sel 10)
--                if idx = 0 then
--                    -- Cargar la llave original (Sel 0)
--                    subkeys(0) <= keyin;
--                    idx := idx + 1;
--                elsif idx <= 43 then
--                    -- Generar las siguientes subllaves
--                    temp := subkeys((idx-1)/4)(31 downto 0);  -- Última palabra de la subllave anterior
--                    
--                    -- Aplicar RotWord + SubWord + Rcon cada 4 palabras
--                    if idx mod 4 = 0 then
--                        temp := SubWord(RotWord(temp)) xor Rcon(idx/4);
--                    end if;
--                    
--                    -- Calcular nueva palabra y almacenar
--                    temp := temp xor subkeys((idx-4)/4)(31 downto 0);
--                    subkeys(idx/4)((idx mod 4)*32 + 31 downto (idx mod 4)*32) <= temp;
--                    
--                    idx := idx + 1;
--                end if;
--                
--                -- Indicar que todas las subllaves están listas
--                if idx = 44 then
--                    keys_ready <= '1';
--                end if;
--            end if;
--        end if;
--    end process;
--
--    -- Paso 2: Acceso a las subllaves en orden inverso (Sel 10 → Sel 0)
--    -- keyout <= subkeys(10 - selint);  -- Por ejemplo, Sel=0 devuelve subkeys[10] (Sel 10)
--	 keyout <= subkeys(10 - to_integer(unsigned(sel)));  -- Por ejemplo, Sel=0 devuelve subkeys[10] (Sel 10)
--    Finish <= keys_ready;              -- '1' cuando las 11 subllaves están listas
--end Behavioral;
--
--
