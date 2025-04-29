------------------------------------------------------------------------------------
---- Company: 
---- Engineers: Team StateMach 
---- 
---- Create Date:    21:08:58 28/04/2025 
---- Design Name: 
---- Module Name:    state_machine - Behavioral 
---- Project Name: 
---- Target Devices: 
---- Tool versions: 
---- Description: 
----
---- Dependencies: 
----
---- Revision: 
---- Revision 0.01 - File Created
---- Additional Comments: 
----
------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity StateMach is
    port(
        -- Señales de control para los módulos
        AddRoundu0En      : out std_logic;
        AddRoundu0Fin     : in  std_logic;
        AddRoundu4En      : out std_logic;
        AddRoundu4Fin     : in  std_logic;
        AddRoundu7En      : out std_logic;
        AddRoundu7Fin     : in  std_logic;
        Clk               : in  std_logic;
        KeyEn             : out std_logic;
        KeyFin            : in  std_logic;
        KeySel            : out std_logic_vector(3 downto 0);
        InvMixColumnsu3En : out std_logic;
        InvMixColumnsu3Fin: in  std_logic;
        MuxSel            : out std_logic;
        Rst               : in  std_logic;
        InvShiftRowsu2En  : out std_logic;
        InvShiftRowsu2Fin : in  std_logic;
        InvShiftRowsu6En  : out std_logic;
        InvShiftRowsu6Fin : in  std_logic;
        InvSubBytesu1En   : out std_logic;
        InvSubBytesu1Fin  : in  std_logic;
        InvSubBytesu5En   : out std_logic;
        InvSubBytesu5Fin  : in  std_logic
    );
end StateMach;

architecture Behavioral of StateMach is

    -- Definición de estados para el descifrado AES
    type ESTADOS is (
        KS,       -- Key Schedule (Expansión de clave)
        ARK1,     -- AddRoundKey (Ronda inicial)
        InvSB1,   -- InvSubBytes
        InvSR1,   -- InvShiftRows
        InvMC,    -- InvMixColumns
        ARK2,     -- AddRoundKey (Rondas intermedias)
        InvSR2,   -- InvShiftRows (última ronda)
        InvSB2,   -- InvSubBytes (última ronda)
        ARK3,     -- AddRoundKey (Ronda final)
        Fin       -- Operación completada
    ); 

    -- Señales internas
    signal ESTACT, SIGEST : ESTADOS; 
    signal s_SelectKey    : std_logic_vector(3 downto 0) := "1010"; -- Inicia en 10 (A en hex)
    signal Finish         : std_logic_vector(8 downto 0); 
    signal Enable         : std_logic_vector(8 downto 0); 

    -- Asignación de bits para las señales de Finish y Enable
    -- ARK3 & SR2 & SB2 &ARK2 & MC & SR1 & SB1 & ARK1 & KS
    --  b8    b7    b6    b5    b4    b3    b2    b1    b0    

    -- Constantes para los patrones de Enable (para mejor legibilidad)
    constant EN_KS      : std_logic_vector(8 downto 0) := "000000001";
    constant EN_ARK1    : std_logic_vector(8 downto 0) := "000000010";
    constant EN_INVSB1  : std_logic_vector(8 downto 0) := "000000100";
    constant EN_INVSR1  : std_logic_vector(8 downto 0) := "000001000";
    constant EN_INVMC   : std_logic_vector(8 downto 0) := "000010000";
    constant EN_ARK2    : std_logic_vector(8 downto 0) := "000100000";
    constant EN_INVSB2  : std_logic_vector(8 downto 0) := "001000000";
    constant EN_INVSR2  : std_logic_vector(8 downto 0) := "010000000";
    constant EN_ARK3    : std_logic_vector(8 downto 0) := "100000000";
    constant EN_FIN     : std_logic_vector(8 downto 0) := "000000000";

begin

    -- Concatenación de señales Finish (para verificación de operaciones completadas)
    Finish <= AddRoundu7Fin & InvShiftRowsu6Fin & InvSubBytesu5Fin & AddRoundu4Fin & 
              InvMixColumnsu3Fin & InvShiftRowsu2Fin & InvSubBytesu1Fin & AddRoundu0Fin & KeyFin;

    -- Proceso para el registro de estados (sincronización con reloj)
    SIGUIENTE : process (Clk, Rst)     
    begin 
        if (Rst = '1') then 
            ESTACT <= KS; -- Reset asíncrono (vuelve al estado inicial)
        elsif (rising_edge(Clk)) then 
            ESTACT <= SIGEST; -- Actualización del estado en flanco de subida
        end if; 
    end process;                        

    -- Lógica del estado siguiente (transiciones)
    CUALSIG: process (ESTACT, Finish) 
    begin 
        case ESTACT is 
            when KS => 
                s_SelectKey <= "1010"; -- Clave inicial (ronda 10)
                Enable <= EN_KS;       -- Activa Key Schedule
                if (Finish(0) = '1') then -- Cuando KeyFin está listo
                    SIGEST <= ARK1;     -- Pasa a AddRoundKey inicial
                end if;                         
            when ARK1 => 
                Enable <= EN_ARK1;      -- Activa AddRound (ronda inicial)
                MuxSel <= '0';          -- Selecciona entrada directa (sin MixColumns)
                if (Finish(1) = '1') then -- Cuando AddRoundu0Fin está listo
                    SIGEST <= InvSR1;  -- Pasa a InvShiftRows
                end if;                         
            when InvSR1 => 
                Enable <= EN_INVSR1;   -- Activa InvShiftRows
                if (Finish(3) = '1') then 
                    SIGEST <= InvSB1;   -- Pasa a InvSubBytes
                end if;                         
            when InvSB1 =>   
                Enable <= EN_INVSB1;   -- Activa InvSubBytes
                if (Finish(2) = '1') then 
                    s_SelectKey <= s_SelectKey - 1; -- Decrementa el número de ronda
                    SIGEST <= ARK2;     -- Pasa a AddRoundKey intermedio
                end if;                         
            when ARK2 => 
                Enable <= EN_ARK2;     -- Activa AddRound (ronda intermedia)                     
                if (Finish(5) = '1') then 
                    if (s_SelectKey = "0000") then -- Si es la última ronda
                        SIGEST <= InvSR2; -- Pasa a InvShiftRows final
                    else 
                        SIGEST <= InvMC;  -- Si no, pasa a InvMixColumns
                    end if;
                end if;                         
            when InvMC => 
                Enable <= EN_INVMC;     -- Activa InvMixColumns  
                MuxSel <= '1';          -- Selecciona entrada con MixColumns
                if (Finish(4) = '1') then 
                    SIGEST <= InvSR1;  -- Vuelve a InvShiftRows (ciclo)
                end if;                         
            when InvSR2 => 
                Enable <= EN_INVSR2;    -- Activa InvShiftRows (última ronda)  
                if (Finish(7) = '1') then 
                    SIGEST <= InvSB2;   -- Pasa a InvSubBytes final
                end if;                         
            when InvSB2 => 
                Enable <= EN_INVSB2;    -- Activa InvSubBytes (última ronda)
                s_SelectKey <= "0000";  -- Fija clave para ronda final                     
                if (Finish(6) = '1') then 
                    SIGEST <= ARK3;     -- Pasa a AddRoundKey final
                end if;                         
            when ARK3 => 
                Enable <= EN_ARK3;      -- Activa AddRound (ronda final)                      
                if (Finish(8) = '1') then 
                    SIGEST <= Fin;      -- Termina operación
                    s_SelectKey <= "1010"; -- Reinicia contador de rondas
                end if;
            when Fin => 
                Enable <= EN_FIN;       -- Desactiva todos los módulos
                SIGEST <= Fin;          -- Permanece en estado Fin
                s_SelectKey <= "0000";  -- Opcional: limpia selección de clave                         
        end case; 
    end process;

    -- Asignación de salidas
    KeySel             <= s_SelectKey;  -- Selector de clave (ronda actual)
    
    -- Asignación de señales de control desde el vector Enable
    KeyEn             <= Enable(0);
    AddRoundu0En      <= Enable(1);
    InvSubBytesu1En   <= Enable(2);
    InvShiftRowsu2En  <= Enable(3);
    InvMixColumnsu3En <= Enable(4);
    AddRoundu4En      <= Enable(5);
    InvSubBytesu5En   <= Enable(6);
    InvShiftRowsu6En  <= Enable(7);
    AddRoundu7En      <= Enable(8);
    
end Behavioral;

