-------------------------------------------------------------------------------
--
-- Title       : 
-- Design      : multiplicador
-- Author      : gabigabiguedes@hotmail.com
-- Company     : USP
--
-------------------------------------------------------------------------------
--
-- File        : c:\Users\gabig\Documents\Trabalhos\Org Arq\Coprocessador\multiplicador\compile\modo_operacao.vhd
-- Generated   : Thu Jun  6 16:24:02 2019
-- From        : c:\Users\gabig\Documents\Trabalhos\Org Arq\Coprocessador\multiplicador\src\modo_operacao.bde
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

entity modo_operacao is
  port(
       clock : in STD_LOGIC;
       read_enable : in STD_LOGIC;
       dadoa : in STD_LOGIC_VECTOR(15 downto 0);
       dadob : in STD_LOGIC_VECTOR(15 downto 0);
       dadocmd : in STD_LOGIC_VECTOR(1 downto 0);
       write_enable : in STD_LOGIC_VECTOR(2 downto 0);
       interrupcao : out STD_LOGIC;
       output : out STD_LOGIC_VECTOR(31 downto 0)
  );
end modo_operacao;

architecture ex1 of modo_operacao is

---- Component declarations -----

component mult_level2
  port (
       clock : in STD_LOGIC;
       enable : in STD_LOGIC;
       in_a : in STD_LOGIC_VECTOR(15 downto 0);
       in_b : in STD_LOGIC_VECTOR(15 downto 0);
       overflow : out STD_LOGIC;
       ready : out STD_LOGIC;
       result : out STD_LOGIC_VECTOR(31 downto 0)
  );
end component;
component raiz_quadrada
  port (
       clock : in STD_LOGIC;
       enable : in STD_LOGIC
  );
end component;
component registrador
  generic(
       NumeroBits : INTEGER := 8
-- synthesis translate_off
       ;
       Tprop : TIME := 5 ns;
       Tsetup : TIME := 2 ns
-- synthesis translate_on
  );
  port (
       C : in STD_LOGIC;
       D : in STD_LOGIC_VECTOR(NumeroBits - 1 downto 0);
       R : in STD_LOGIC;
       S : in STD_LOGIC;
       enable : in STD_LOGIC;
       Q : out STD_LOGIC_VECTOR(NumeroBits - 1 downto 0)
  );
end component;

---- Signal declarations used on the diagram ----

signal d0 : STD_LOGIC;
signal d1 : STD_LOGIC;
signal d2 : STD_LOGIC;
signal d3 : STD_LOGIC;
signal enable_a : STD_LOGIC;
signal enable_b : STD_LOGIC;
signal enable_cmd : STD_LOGIC;
signal enable_e : STD_LOGIC;
signal enable_m : STD_LOGIC;
signal enable_r : STD_LOGIC;
signal enable_st : STD_LOGIC;
signal overflow : STD_LOGIC;
signal ra : STD_LOGIC;
signal rb : STD_LOGIC;
signal rcmd : STD_LOGIC;
signal re : STD_LOGIC;
signal ready_m : STD_LOGIC;
signal rest : INTEGER range 0 TO 1382146816;
signal rst : STD_LOGIC;
signal sa : STD_LOGIC;
signal sb : STD_LOGIC;
signal scmd : STD_LOGIC;
signal se : STD_LOGIC;
signal sst : STD_LOGIC;
signal dadoe : STD_LOGIC_VECTOR(3 downto 0);
signal output_int : STD_LOGIC_VECTOR(31 downto 0);
signal result : STD_LOGIC_VECTOR(31 downto 0);
signal saidaa : STD_LOGIC_VECTOR(15 downto 0);
signal saidab : STD_LOGIC_VECTOR(15 downto 0);
signal saidacmd : STD_LOGIC_VECTOR(1 downto 0);
signal saidae : STD_LOGIC_VECTOR(3 downto 0);
signal saidast : STD_LOGIC_VECTOR(31 downto 0);
signal set_cmd : STD_LOGIC_VECTOR(2 downto 0);

begin

---- User Signal Assignments ----
with write_enable select enable_a <= '1' when "001", '0' when others;
with write_enable select enable_b <= '1' when "010", '0' when others;
with write_enable select enable_cmd <= '1' when "011", '0' when others;
with write_enable select enable_e <= '1' when "100", '0' when others;
with saidacmd select enable_st <= ready_m when "01", '0' when others;
dadoe <= d3 & d2 & d1 & d0;
set_cmd <= enable_cmd & saidacmd;
with set_cmd select enable_m <= '1' when "001", '0' when others;
with set_cmd select enable_r <= '1' when "010", '0' when others;
with output_int select d1 <= '1' when "00000000000000000000000000000000", '0' when others;
with set_cmd select d0 <= '1' when "010", '1' when "001", '1' when "100", '1' when "101", '1' when "110", '0' when others;
with saidacmd select d2 <= overflow when "10", '0' when others;
with saidacmd select d3 <= ready_m when "10", '0' when others;

----  Component instantiations  ----

Multiplicador : mult_level2
  port map(
       clock => clock,
       enable => enable_m,
       in_a => saidaa,
       in_b => saidab,
       overflow => overflow,
       ready => ready_m,
       result => result
  );

Raiz : raiz_quadrada
  port map(
       clock => clock,
       enable => enable_r
  );

Rega : registrador
  generic map(
       NumeroBits => 16
  )
  port map(
       C => clock,
       D => dadoa(15 downto 0),
       Q => saidaa(15 downto 0),
       R => ra,
       S => sa,
       enable => enable_a
  );

Regb : registrador
  generic map(
       NumeroBits => 16
  )
  port map(
       C => clock,
       D => dadob(15 downto 0),
       Q => saidab(15 downto 0),
       R => rb,
       S => sb,
       enable => enable_b
  );

Regcmd : registrador
  generic map(
       NumeroBits => 2
  )
  port map(
       C => clock,
       D => dadocmd(1 downto 0),
       Q => saidacmd(1 downto 0),
       R => rcmd,
       S => scmd,
       enable => enable_cmd
  );

Rege : registrador
  generic map(
       NumeroBits => 4
  )
  port map(
       C => clock,
       D => dadoe(3 downto 0),
       Q => saidae(3 downto 0),
       R => re,
       S => se,
       enable => '1'
  );

Regst : registrador
  generic map(
       NumeroBits => 32
  )
  port map(
       C => clock,
       D => result(31 downto 0),
       Q => output_int(31 downto 0),
       R => rst,
       S => sst,
       enable => enable_st
  );


---- Terminal assignment ----

    -- Output\buffer terminals
	interrupcao <= saidae(3);
	output <= output_int;


end ex1;
