-------------------------------------------------------------------------------
--
-- Title       : 
-- Design      : multiplicador
-- Author      : gabigabiguedes@hotmail.com
-- Company     : USP
--
-------------------------------------------------------------------------------
--
-- File        : c:\Users\gabig\Documents\Trabalhos\Org Arq\Coprocessador\multiplicador\compile\raiz_quadrada.vhd
-- Generated   : Thu Jun  6 15:18:04 2019
-- From        : c:\Users\gabig\Documents\Trabalhos\Org Arq\Coprocessador\multiplicador\..\..\Trabalho\raiz_quadrada.bde
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

entity raiz_quadrada is
  port(
       clock : in STD_LOGIC;
       enable : in STD_LOGIC;
       A : in STD_LOGIC_VECTOR(15 downto 0);
       e : in STD_LOGIC_VECTOR(15 downto 0);
       ready1 : out STD_LOGIC;
       S : out STD_LOGIC_VECTOR(15 downto 0)
  );
end raiz_quadrada;

architecture ex1 of raiz_quadrada is

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

---- Signal declarations used on the diagram ----

signal enable2 : STD_LOGIC := '0';
signal overflow : STD_LOGIC;
signal ready : STD_LOGIC;
signal ready2 : STD_LOGIC;
signal ready3 : STD_LOGIC;
signal aux : STD_LOGIC_VECTOR(15 downto 0);
signal error : STD_LOGIC_VECTOR(15 downto 0) := "0000000100000000";
signal res : STD_LOGIC_VECTOR(15 downto 0);
signal res2 : STD_LOGIC_VECTOR(15 downto 0);
signal res3 : STD_LOGIC_VECTOR(15 downto 0);
signal res4 : STD_LOGIC_VECTOR(15 downto 0);
signal X : STD_LOGIC_VECTOR(15 downto 0);
signal x_0 : STD_LOGIC_VECTOR(15 downto 0);
signal x_0_2 : STD_LOGIC_VECTOR(15 downto 0);

begin

---- Processes ----

process (res2)
                       begin
                         if ready2 = '1' then
                            res3 <= conv_std_logic_vector(768 - conv_integer(unsigned(res2)),16);
                            enable2 <= '1';
                         end if;
                       end process;
                      

process (res4)
                       begin
                         if ready3 = '1' then
                            error <= conv_std_logic_vector(conv_integer(unsigned(res4)) - conv_integer(unsigned(x_0)),16);
                            ready1 <= '1';
                         end if;
                       end process;
                      

---- User Signal Assignments ----
aux <= x_0;
x_0_2 <= "0" & x_0(15 downto 1);

----  Component instantiations  ----

Mult1 : mult_level1
  port map(
       clock => clock,
       enable => enable,
       in_a => x_0,
       in_b => aux,
       overflow => overflow,
       ready => ready,
       result => res
  );

Mult2 : mult_level1
  port map(
       clock => clock,
       enable => ready,
       in_a => X,
       in_b => res,
       overflow => overflow,
       ready => ready2,
       result => res2
  );

Mult3 : mult_level1
  port map(
       clock => clock,
       enable => enable2,
       in_a => x_0_2,
       in_b => res3,
       overflow => overflow,
       ready => ready3,
       result => res4
  );


---- Terminal assignment ----

    -- Inputs terminals
	X <= A;
	x_0 <= e;

    -- Output\buffer terminals
	S <= res4;


end ex1;
