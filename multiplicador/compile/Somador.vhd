-------------------------------------------------------------------------------
--
-- Title       : 
-- Design      : multiplicador
-- Author      : gabigabiguedes@hotmail.com
-- Company     : USP
--
-------------------------------------------------------------------------------
--
-- File        : c:\Users\gabig\Documents\Trabalhos\Org Arq\Coprocessador\multiplicador\compile\Somador.vhd
-- Generated   : Thu Jun  6 15:18:06 2019
-- From        : c:\Users\gabig\Documents\Trabalhos\Org Arq\Coprocessador\multiplicador\src\Somador.bde
-- By          : Bde2Vhdl ver. 2.6
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------
-- Design unit header --
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.STD_LOGIC_SIGNED.all;

entity Somador is
  generic(
       NumeroBits : integer := 8;
       Tsoma : time := 3 ns;
       Tinc : time := 2 ns
  );
  port(
       S : in STD_LOGIC;
       Vum : in STD_LOGIC;
       A : in STD_LOGIC_VECTOR(NumeroBits - 1 downto 0);
       B : in STD_LOGIC_VECTOR(NumeroBits - 1 downto 0);
       C : out STD_LOGIC_VECTOR(NumeroBits - 1 downto 0)
  );
end Somador;

architecture Somador of Somador is

begin

---- User Signal Assignments ----
C <= (A + B + Vum) after Tsoma when S = '1' else (A + Vum) after Tinc;

end Somador;
