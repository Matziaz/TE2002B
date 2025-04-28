--    LASTTRAINWARE IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"
--    SOLELY FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR
--    xILINX AND ALTERA DEVICES.
--
---------------------------------------------------------------------------------
--   Title      : MixColumn Block Functions for Rijndael Encryption
--   Project    : XUP-V2Pro 
---------------------------------------------------------------------------------
--
--   File       : GALOISPACKAGE.VHDL
--   Company    : ITESM CQ
--   Created    : 2009/05/06
--   Last Update: 2009/05/06
--   Copyright  : (c) LasttrainWare Inc, 2009
--------------------------------------------------------------------------------
--	  Purpose: This package defines two functions. First one, multiplication of two numbers using
--   finite field arithmetics. To multiply two numbers according to Galois Fields its necessary to
--   perform a modified version of peasant's algorithm. 
--	  Second function is MixColumn.

--   Noe escribe aqui lo que hace la funcion MixColumn y los respectivos comentarios abajo.
---------------------------------------------------------------------------------- 


library IEEE;
use IEEE.STD_LOGIC_1164.all;

package GaloisPackage is
 
-- Declare functions and procedure
  function Modulo  ( NumA : STD_LOGIC_VECTOR;
						   NumB : STD_LOGIC_VECTOR	) return STD_LOGIC_VECTOR;
  function MixColumn ( Cadena : STD_LOGIC_VECTOR ) return STD_LOGIC_VECTOR;

end GaloisPackage;

package body GaloisPackage is

-- Example 2
  function Modulo  ( NumA : STD_LOGIC_VECTOR;
						   NumB : STD_LOGIC_VECTOR	) return STD_LOGIC_VECTOR is
	variable a      : STD_LOGIC_VECTOR(7 downto 0);
	variable b      : STD_LOGIC_VECTOR(7 downto 0);
	variable p      : STD_LOGIC_VECTOR(7 downto 0);
	variable aux    : STD_LOGIC_VECTOR(7 downto 0);
	variable hi_bit : STD_LOGIC_VECTOR(7 downto 0);
  begin
		a := NumA;									-- Copy of first number
		b := NumB;			         			-- Copy of second number
		p := "00000000";
		for i in 0 to 7 loop						--Peasant Algorithm
			aux := b and "00000001";			--Check if LSB of b is 1
			if(aux = "00000001") then			--If true xor p(result) and a(first number)
				p := p xor a;
			end if;
			hi_bit := a and "10000000";		--Check if MSB of a is 1
			a := a(6 downto 0) & '0';			--Shift left a one bit
			if(hi_bit = "10000000") then		--If a MSB is set xor a with 0x1B (an irreducible polynomial) 
				a := a xor "00011011";        --The comparison is with 0x1B because the condition includes 0x80.
			end if;
			b := '0' & b(7 downto 1);			--Shit right b one bit. This algorithm is performed 8 times. 
		end loop;
		return p;									--Return value of p(result)
  end Modulo;
  
  function MixColumn ( Cadena : STD_LOGIC_VECTOR ) return STD_LOGIC_VECTOR is
	
	variable D0  : STD_LOGIC_VECTOR(7 downto 0); variable D1  : STD_LOGIC_VECTOR(7 downto 0);
	variable D2  : STD_LOGIC_VECTOR(7 downto 0); variable D3  : STD_LOGIC_VECTOR(7 downto 0);
	variable D4  : STD_LOGIC_VECTOR(7 downto 0); variable D5  : STD_LOGIC_VECTOR(7 downto 0);
	variable D6  : STD_LOGIC_VECTOR(7 downto 0); variable D7  : STD_LOGIC_VECTOR(7 downto 0);
	variable D8  : STD_LOGIC_VECTOR(7 downto 0); variable D9  : STD_LOGIC_VECTOR(7 downto 0);
	variable D10 : STD_LOGIC_VECTOR(7 downto 0); variable D11 : STD_LOGIC_VECTOR(7 downto 0);
	variable D12 : STD_LOGIC_VECTOR(7 downto 0); variable D13 : STD_LOGIC_VECTOR(7 downto 0);
	variable D14 : STD_LOGIC_VECTOR(7 downto 0); variable D15 : STD_LOGIC_VECTOR(7 downto 0);
	variable Output : STD_LOGIC_VECTOR(127 downto 0);
	
  begin
	
	--Separation order of the entrance variable into independent variables
	--D0  D4  D8 D12
	--D1  D5  D9 D13
	--D2  D6 D10 D14
	--D3  D7 D11 D15	
	
	D0 := Cadena(127 downto 120); D1 := Cadena(119 downto 112);
	D2 := Cadena(111 downto 104); D3 := Cadena(103 downto 96);
	
	D4 := Cadena(95 downto 88);   D5 := Cadena(87 downto 80);
	D6 := Cadena(79 downto 72);   D7 := Cadena(71 downto 64);
	
	D8 := Cadena(63 downto 56);   D9 := Cadena(55 downto 48);
	D10 := Cadena(47 downto 40);  D11 := Cadena(39 downto 32);
	
	D12 := Cadena(31 downto 24);  D13 := Cadena(23 downto 16);
	D14 := Cadena(15 downto 8);   D15 := Cadena(7 downto 0);
	
	--Cálculo de matriz final, en los comentarios de las siguientes líneas de código se puede apreciar
	--qué valor de la matriz se está calculando
	Output(127 downto 120) := Modulo(D0,X"02") xor Modulo(D1,X"03") xor D2 xor D3;     --X000
	Output(119 downto 112) := D0 xor Modulo(D1,X"02") xor Modulo(D2,X"03") xor D3;     --X000
	Output(111 downto 104) := Modulo(D2,X"02") xor Modulo(D3,X"03") xor D0 xor D1;     --X000
	Output(103 downto 96)  := Modulo(D0,X"03") xor Modulo(D3,X"02") xor D1 xor D2;     --X000
	
	Output(95 downto 88)   := Modulo(D4,X"02") xor Modulo(D5,X"03") xor D6 xor D7;     --0X00
	Output(87 downto 80)   := Modulo(D5,X"02") xor Modulo(D6,X"03") xor D4 xor D7;     --0X00
	Output(79 downto 72)   := Modulo(D6,X"02") xor Modulo(D7,X"03") xor D4 xor D5;     --0X00
	Output(71 downto 64)   := Modulo(D4,X"03") xor Modulo(D7,X"02") xor D5 xor D6;     --0X00
	 
	Output(63 downto 56)   := Modulo(D8,X"02") xor Modulo(D9,X"03") xor D10 xor D11;   --00X0
	Output(55 downto 48)   := Modulo(D9,X"02") xor Modulo(D10,X"03") xor D8 xor D11;   --00X0
	Output(47 downto 40)   := Modulo(D10,X"02") xor Modulo(D11,X"03") xor D8 xor D9;   --00X0
	Output(39 downto 32)   := Modulo(D8,X"03") xor Modulo(D11,X"02") xor D9 xor D10;   --00X0
	
	Output(31 downto 24)   := Modulo(D12,X"02") xor Modulo(D13,X"03") xor D14 xor D15; --000X
	Output(23 downto 16)   := Modulo(D13,X"02") xor Modulo(D14,X"03") xor D12 xor D15; --000X
	Output(15 downto 8)    := Modulo(D14,X"02") xor Modulo(D15,X"03") xor D12 xor D13; --000X
	Output(7 downto 0)     := Modulo(D12,X"03") xor Modulo(D15,X"02") xor D13 xor D14; --000X
	
	return Output;
	
  end MixColumn;
 end GaloisPackage;
