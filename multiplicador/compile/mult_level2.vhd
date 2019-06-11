-------------------------------------------------------------------------------
--
-- Title       : 
-- Design      : multiplicador
-- Author      : gabigabiguedes@hotmail.com
-- Company     : USP
--
-------------------------------------------------------------------------------
--
-- File        : c:\Users\gabig\Documents\Trabalhos\Org Arq\Coprocessador\multiplicador\compile\mult_level2.vhd
-- Generated   : Thu Jun  6 15:18:03 2019
-- From        : c:\Users\gabig\Documents\Trabalhos\Org Arq\Coprocessador\multiplicador\src\mult_level2.bde
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

entity mult_level2 is
  port(
       clock : in STD_LOGIC;
       enable : in STD_LOGIC;
       in_a : in STD_LOGIC_VECTOR(15 downto 0);
       in_b : in STD_LOGIC_VECTOR(15 downto 0);
       overflow : out STD_LOGIC;
       ready : out STD_LOGIC;
       result : out STD_LOGIC_VECTOR(31 downto 0)
  );
end mult_level2;

architecture ex1 of mult_level2 is

---- Component declarations -----

component multiplicador_16
  port (
       clock : in STD_LOGIC;
       enable : in STD_LOGIC;
       in_a : in STD_LOGIC_VECTOR(15 downto 0);
       in_b : in STD_LOGIC_VECTOR(15 downto 0);
       ready : out STD_LOGIC;
       res : out STD_LOGIC_VECTOR(32 downto 0)
  );
end component;

---- Signal declarations used on the diagram ----

signal acabou : STD_LOGIC;
signal a : STD_LOGIC_VECTOR(15 downto 0);
signal b : STD_LOGIC_VECTOR(15 downto 0);
signal inta : STD_LOGIC_VECTOR(15 downto 0);
signal intb : STD_LOGIC_VECTOR(15 downto 0);
signal res : STD_LOGIC_VECTOR(32 downto 0);
signal res_int : STD_LOGIC_VECTOR(15 downto 0);
signal res_int1 : STD_LOGIC_VECTOR(31 downto 0);
signal sinal : STD_LOGIC_VECTOR(1 downto 0);

begin

---- Processes ----

process (acabou)
                       begin
                         if acabou'event and acabou = '1' then
                            ready <= '1';
                         else 
                            ready <= '0';
                         end if;
                       end process;
                      

---- User Signal Assignments ----
res_int1 <= res(31 downto 0);
sinal <= in_a(15) & in_b(15);
inta <= not (in_a);
intb <= not (in_b);
with sinal select a <= conv_std_logic_vector(conv_integer(unsigned(in_a)),16) when "00", conv_std_logic_vector(conv_integer(unsigned(in_a)),16) when "01", conv_std_logic_vector(conv_integer(unsigned(inta)) + 1,16) when "10", conv_std_logic_vector(conv_integer(unsigned(inta)) + 1,16) when "11", "0000000000000000" when others;
with sinal select b <= conv_std_logic_vector(conv_integer(unsigned(in_b)),16) when "00", conv_std_logic_vector(conv_integer(unsigned(intb)) + 1,16) when "01", conv_std_logic_vector(conv_integer(unsigned(in_b)),16) when "10", conv_std_logic_vector(conv_integer(unsigned(intb)) + 1,16) when "11", "0000000000000000" when others;
with sinal select result <= res_int1 when "00", conv_std_logic_vector(conv_integer(unsigned(not (res_int1))) + 1,32) when "01", conv_std_logic_vector(conv_integer(unsigned(not (res_int1))) + 1,32) when "10", res_int1 when "11", "00000000000000000000000000000000" when others;

----  Component instantiations  ----

Multiplicador : multiplicador_16
  port map(
       clock => clock,
       enable => enable,
       in_a => a,
       in_b => b,
       ready => acabou,
       res => res
  );


---- Terminal assignment ----

    -- Output\buffer terminals
	overflow <= res(32);


end ex1;
