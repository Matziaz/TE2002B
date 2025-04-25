-- StateMach.vhd: Máquina de estados completa para el flujo de desencriptado AES
library ieee;
use ieee.std_logic_1164.all;

entity StateMach is
  port(
    Clk            : in  std_logic;
    Rst            : in  std_logic;
    -- Señales de control para cada etapa
    SubBytesEn     : out std_logic;  SubBytesFin    : in  std_logic;
    ShiftRowsEn    : out std_logic;  ShiftRowsFin   : in  std_logic;
    MixColumnsEn   : out std_logic;  MixColumnsFin  : in  std_logic;
    AddRoundKeyEn  : out std_logic;  AddRoundKeyFin : in  std_logic;
    KeyEn          : out std_logic;  KeyFin         : in  std_logic;
    MuxSel         : out std_logic
  );
end entity StateMach;

architecture rtl of StateMach is
  type t_state is (
    IDLE,
    -- Ronda inicial
    INIT_ADDROUND,
    -- Rondas 1 a 9
    R1_INVSUB,  R1_INVSHFT,  R1_ADD,  R1_INVMIX,
    R2_INVSUB,  R2_INVSHFT,  R2_ADD,  R2_INVMIX,
    R3_INVSUB,  R3_INVSHFT,  R3_ADD,  R3_INVMIX,
    R4_INVSUB,  R4_INVSHFT,  R4_ADD,  R4_INVMIX,
    R5_INVSUB,  R5_INVSHFT,  R5_ADD,  R5_INVMIX,
    R6_INVSUB,  R6_INVSHFT,  R6_ADD,  R6_INVMIX,
    R7_INVSUB,  R7_INVSHFT,  R7_ADD,  R7_INVMIX,
    R8_INVSUB,  R8_INVSHFT,  R8_ADD,  R8_INVMIX,
    R9_INVSUB,  R9_INVSHFT,  R9_ADD,  R9_INVMIX,
    -- Ronda final (sin InvMixColumns)
    FINAL_INVSUB, FINAL_INVSHFT, FINAL_ADDROUND,
    DONE
  );
  signal state, next_state : t_state;
begin

  -- Registro de estado
  p_reg: process(Clk, Rst) begin
    if Rst = '1' then
      state <= IDLE;
    elsif rising_edge(Clk) then
      state <= next_state;
    end if;
  end process p_reg;

  -- Lógica combinacional: transición de estados y control de salidas
  p_comb: process(state,
                  SubBytesFin, ShiftRowsFin,
                  MixColumnsFin, AddRoundKeyFin, KeyFin) begin
    -- Valores por defecto
    SubBytesEn     <= '0';
    ShiftRowsEn    <= '0';
    MixColumnsEn   <= '0';
    AddRoundKeyEn  <= '0';
    KeyEn          <= '0';
    MuxSel         <= '0';

    case state is

      -- Estado inicial: arrancar la primera AddRoundKey
      when IDLE =>
        AddRoundKeyEn <= '1';
        next_state    <= INIT_ADDROUND;

      when INIT_ADDROUND =>
        if AddRoundKeyFin = '1' then
          next_state <= R1_INVSUB;
        else
          next_state <= INIT_ADDROUND;
        end if;

      -- Ronda 1
      when R1_INVSUB =>
        SubBytesEn <= '1';
        if SubBytesFin = '1' then
          next_state <= R1_INVSHFT;
        else
          next_state <= R1_INVSUB;
        end if;
      when R1_INVSHFT =>
        ShiftRowsEn <= '1';
        if ShiftRowsFin = '1' then
          next_state <= R1_ADD;
        else
          next_state <= R1_INVSHFT;
        end if;
      when R1_ADD =>
        AddRoundKeyEn <= '1';
        if AddRoundKeyFin = '1' then
          next_state <= R1_INVMIX;
        else
          next_state <= R1_ADD;
        end if;
      when R1_INVMIX =>
        MixColumnsEn <= '1';
        if MixColumnsFin = '1' then
          next_state <= R2_INVSUB;
        else
          next_state <= R1_INVMIX;
        end if;

      -- Ronda 2
      when R2_INVSUB =>
        SubBytesEn <= '1';
        if SubBytesFin = '1' then
          next_state <= R2_INVSHFT;
        else
          next_state <= R2_INVSUB;
        end if;
      when R2_INVSHFT =>
        ShiftRowsEn <= '1';
        if ShiftRowsFin = '1' then
          next_state <= R2_ADD;
        else
          next_state <= R2_INVSHFT;
        end if;
      when R2_ADD =>
        AddRoundKeyEn <= '1';
        if AddRoundKeyFin = '1' then
          next_state <= R2_INVMIX;
        else
          next_state <= R2_ADD;
        end if;
      when R2_INVMIX =>
        MixColumnsEn <= '1';
        if MixColumnsFin = '1' then
          next_state <= R3_INVSUB;
        else
          next_state <= R2_INVMIX;
        end if;

      -- Ronda 3
      when R3_INVSUB =>
        SubBytesEn <= '1';
        if SubBytesFin = '1' then
          next_state <= R3_INVSHFT;
        else
          next_state <= R3_INVSUB;
        end if;
      when R3_INVSHFT =>
        ShiftRowsEn <= '1';
        if ShiftRowsFin = '1' then
          next_state <= R3_ADD;
        else
          next_state <= R3_INVSHFT;
        end if;
      when R3_ADD =>
        AddRoundKeyEn <= '1';
        if AddRoundKeyFin = '1' then
          next_state <= R3_INVMIX;
        else
          next_state <= R3_ADD;
        end if;
      when R3_INVMIX =>
        MixColumnsEn <= '1';
        if MixColumnsFin = '1' then
          next_state <= R4_INVSUB;
        else
          next_state <= R3_INVMIX;
        end if;

      -- Ronda 4
      when R4_INVSUB =>
        SubBytesEn <= '1';
        if SubBytesFin = '1' then
          next_state <= R4_INVSHFT;
        else
          next_state <= R4_INVSUB;
        end if;
      when R4_INVSHFT =>
        ShiftRowsEn <= '1';
        if ShiftRowsFin = '1' then
          next_state <= R4_ADD;
        else
          next_state <= R4_INVSHFT;
        end if;
      when R4_ADD =>
        AddRoundKeyEn <= '1';
        if AddRoundKeyFin = '1' then
          next_state <= R4_INVMIX;
        else
          next_state <= R4_ADD;
        end if;
      when R4_INVMIX =>
        MixColumnsEn <= '1';
        if MixColumnsFin = '1' then
          next_state <= R5_INVSUB;
        else
          next_state <= R4_INVMIX;
        end if;

      -- Ronda 5
      when R5_INVSUB =>
        SubBytesEn <= '1';
        if SubBytesFin = '1' then
          next_state <= R5_INVSHFT;
        else
          next_state <= R5_INVSUB;
        end if;
      when R5_INVSHFT =>
        ShiftRowsEn <= '1';
        if ShiftRowsFin = '1' then
          next_state <= R5_ADD;
        else
          next_state <= R5_INVSHFT;
        end if;
      when R5_ADD =>
        AddRoundKeyEn <= '1';
        if AddRoundKeyFin = '1' then
          next_state <= R5_INVMIX;
        else
          next_state <= R5_ADD;
        end if;
      when R5_INVMIX =>
        MixColumnsEn <= '1';
        if MixColumnsFin = '1' then
          next_state <= R6_INVSUB;
        else
          next_state <= R5_INVMIX;
        end if;

      -- Ronda 6
      when R6_INVSUB =>
        SubBytesEn <= '1';
        if SubBytesFin = '1' then
          next_state <= R6_INVSHFT;
        else
          next_state <= R6_INVSUB;
        end if;
      when R6_INVSHFT =>
        ShiftRowsEn <= '1';
        if ShiftRowsFin = '1' then
          next_state <= R6_ADD;
        else
          next_state <= R6_INVSHFT;
        end if;
      when R6_ADD =>
        AddRoundKeyEn <= '1';
        if AddRoundKeyFin = '1' then
          next_state <= R6_INVMIX;
        else
          next_state <= R6_ADD;
        end if;
      when R6_INVMIX =>
        MixColumnsEn <= '1';
        if MixColumnsFin = '1' then
          next_state <= R7_INVSUB;
        else
          next_state <= R6_INVMIX;
        end if;

      -- Ronda 7
      when R7_INVSUB =>
        SubBytesEn <= '1';
        if SubBytesFin = '1' then
          next_state <= R7_INVSHFT;
        else
          next_state <= R7_INVSUB;
        end if;
      when R7_INVSHFT =>
        ShiftRowsEn <= '1';
        if ShiftRowsFin = '1' then
          next_state <= R7_ADD;
        else
          next_state <= R7_INVSHFT;
        end if;
      when R7_ADD =>
        AddRoundKeyEn <= '1';
        if AddRoundKeyFin = '1' then
          next_state <= R7_INVMIX;
        else
          next_state <= R7_ADD;
        end if;
      when R7_INVMIX =>
        MixColumnsEn <= '1';
        if MixColumnsFin = '1' then
          next_state <= R8_INVSUB;
        else
          next_state <= R7_INVMIX;
        end if;

      -- Ronda 8
      when R8_INVSUB =>
        SubBytesEn <= '1';
        if SubBytesFin = '1' then
          next_state <= R8_INVSHFT;
        else
          next_state <= R8_INVSUB;
        end if;
      when R8_INVSHFT =>
        ShiftRowsEn <= '1';
        if ShiftRowsFin = '1' then
          next_state <= R8_ADD;
        else
          next_state <= R8_INVSHFT;
        end if;
      when R8_ADD =>
        AddRoundKeyEn <= '1';
        if AddRoundKeyFin = '1' then
          next_state <= R8_INVMIX;
        else
          next_state <= R8_ADD;
        end if;
      when R8_INVMIX =>
        MixColumnsEn <= '1';
        if MixColumnsFin = '1' then
          next_state <= R9_INVSUB;
        else
          next_state <= R8_INVMIX;
        end if;

      -- Ronda 9
      when R9_INVSUB =>
        SubBytesEn <= '1';
        if SubBytesFin = '1' then
          next_state <= R9_INVSHFT;
        else
          next_state <= R9_INVSUB;
        end if;
      when R9_INVSHFT =>
        ShiftRowsEn <= '1';
        if ShiftRowsFin = '1' then
          next_state <= R9_ADD;
        else
          next_state <= R9_INVSHFT;
        end if;
      when R9_ADD =>
        AddRoundKeyEn <= '1';
        if AddRoundKeyFin = '1' then
          next_state <= R9_INVMIX;
        else
          next_state <= R9_ADD;
        end if;
      when R9_INVMIX =>
        MixColumnsEn <= '1';
        if MixColumnsFin = '1' then
          next_state <= FINAL_INVSUB;
        else
          next_state <= R9_INVMIX;
        end if;

      -- Ronda final (sin InvMixColumns)
      when FINAL_INVSUB =>
        SubBytesEn <= '1';
        if SubBytesFin = '1' then
          next_state <= FINAL_INVSHFT;
        else
          next_state <= FINAL_INVSUB;
        end if;
      when FINAL_INVSHFT =>
        ShiftRowsEn <= '1';
        if ShiftRowsFin = '1' then
          next_state <= FINAL_ADDROUND;
        else
          next_state <= FINAL_INVSHFT;
        end if;
      when FINAL_ADDROUND =>
        AddRoundKeyEn <= '1';
        MuxSel        <= '1';
        if KeyFin = '1' then
          next_state <= DONE;
        else
          next_state <= FINAL_ADDROUND;
        end if;

      -- Estado de terminación
      when DONE =>
        next_state <= DONE;

      when others =>
        next_state <= IDLE;
    end case;
  end process p_comb;

end architecture rtl;