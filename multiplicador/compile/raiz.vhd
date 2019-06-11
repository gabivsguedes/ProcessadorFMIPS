-------------------------------------------------------------------------------
--
-- Title       : 
-- Design      : multiplicador
-- Author      : gabigabiguedes@hotmail.com
-- Company     : USP
--
-------------------------------------------------------------------------------
--
-- File        : c:\Users\gabig\Documents\Trabalhos\Org Arq\Coprocessador\multiplicador\compile\raiz.vhd
-- Generated   : Thu Jun  6 15:18:07 2019
-- From        : c:\Users\gabig\Documents\Trabalhos\Org Arq\Coprocessador\multiplicador\..\..\Trabalho\raiz.bde
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

entity raiz is
  port(
       clock : in STD_LOGIC;
       enable : in STD_LOGIC;
       A : in STD_LOGIC_VECTOR(15 downto 0);
       S2 : out STD_LOGIC_VECTOR(15 downto 0)
  );
end raiz;

architecture raiz of raiz is

---- Component declarations -----

component mult_level1
  port (
       clock : in STD_LOGIC;
       enable : in STD_LOGIC;
       in_a : in STD_LOGIC_VECTOR(15 downto 0);
       in_b : in STD_LOGIC_VECTOR(15 downto 0);
       overflow : out STD_LOGIC;
       ready : out STD_LOGIC;
       result : out STD_LOGIC_VECTOR(15 downto 0)
  );
end component;
component raiz_quadrada
  port (
       A : in STD_LOGIC_VECTOR(15 downto 0);
       clock : in STD_LOGIC;
       e : in STD_LOGIC_VECTOR(15 downto 0);
       enable : in STD_LOGIC;
       S : out STD_LOGIC_VECTOR(15 downto 0);
       ready1 : out STD_LOGIC
  );
end component;

---- Signal declarations used on the diagram ----

signal overflow : STD_LOGIC;
signal ready : STD_LOGIC;
signal ready2 : STD_LOGIC;
signal ready3 : STD_LOGIC;
signal ready4 : STD_LOGIC;
signal ready5 : STD_LOGIC;
signal ready6 : STD_LOGIC;
signal x0 : STD_LOGIC_VECTOR(15 downto 0) := "0000000000111000";
signal x1 : STD_LOGIC_VECTOR(15 downto 0);
signal x2 : STD_LOGIC_VECTOR(15 downto 0);
signal x3 : STD_LOGIC_VECTOR(15 downto 0);
signal x4 : STD_LOGIC_VECTOR(15 downto 0);
signal x5 : STD_LOGIC_VECTOR(15 downto 0);
signal x6 : STD_LOGIC_VECTOR(15 downto 0);

begin

----  Component instantiations  ----

Mult : mult_level1
  port map(
       clock => clock,
       enable => ready5,
       in_a => A,
       in_b => x5,
       overflow => overflow,
       ready => ready6,
       result => x6
  );

Raiz1 : raiz_quadrada
  port map(
       A => A,
       S => x1,
       clock => clock,
       e => x0,
       enable => enable,
       ready1 => ready
  );

Raiz2 : raiz_quadrada
  port map(
       A => A,
       S => x2,
       clock => clock,
       e => x1,
       enable => ready,
       ready1 => ready2
  );

Raiz3 : raiz_quadrada
  port map(
       A => A,
       S => x3,
       clock => clock,
       e => x2,
       enable => ready2,
       ready1 => ready3
  );

Raiz4 : raiz_quadrada
  port map(
       A => A,
       S => x4,
       clock => clock,
       e => x3,
       enable => ready3,
       ready1 => ready4
  );

Raiz5 : raiz_quadrada
  port map(
       A => A,
       S => x5,
       clock => clock,
       e => x4,
       enable => ready4,
       ready1 => ready5
  );


---- Terminal assignment ----

    -- Output\buffer terminals
	S2 <= x6;


end raiz;
