-------------------------------------------------------------------------------
--
-- Title       : 
-- Design      : multiplicador
-- Author      : gabigabiguedes@hotmail.com
-- Company     : USP
--
-------------------------------------------------------------------------------
--
-- File        : c:\Users\gabig\Documents\Trabalhos\Org Arq\Coprocessador\multiplicador\compile\multiplicador_16.vhd
-- Generated   : Thu Jun  6 15:18:02 2019
-- From        : c:\Users\gabig\Documents\Trabalhos\Org Arq\Coprocessador\multiplicador\src\multiplicador_16.bde
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

entity multiplicador_16 is
  port(
       clock : in STD_LOGIC;
       enable : in STD_LOGIC;
       in_a : in STD_LOGIC_VECTOR(15 downto 0);
       in_b : in STD_LOGIC_VECTOR(15 downto 0);
       ready : out STD_LOGIC;
       res : out STD_LOGIC_VECTOR(32 downto 0)
  );
end multiplicador_16;

architecture ex1 of multiplicador_16 is

---- Signal declarations used on the diagram ----

signal a : INTEGER range 0 TO 105535;
signal acabou : STD_LOGIC;
signal b : INTEGER range 0 TO 105535;

begin

---- Processes ----

process (clock,enable)
                         variable size_b : integer range 0 to 105535;
                         variable output : integer range 0 to 1382146816;
                       begin
                         if clock'event and clock = '1' then
                            if enable = '1' and acabou /= '1' then
                               size_b := size_b + 1;
                               output := output + a;
                               if size_b = b then
                                  acabou <= '1';
                                  ready <= '1';
                                  res <= conv_std_logic_vector(output,33);
                               elsif b = 0 or a = 0 then
                                  acabou <= '1';
                                  ready <= '1';
                                  res <= conv_std_logic_vector(0,33);
                               else 
                                  ready <= '0';
                                  acabou <= '0';
                               end if;
                            else 
                               output := 0;
                               size_b := 0;
                            end if;
                         end if;
                       end process;
                      

---- User Signal Assignments ----
a <= conv_integer(unsigned(in_a));
b <= conv_integer(unsigned(in_b));

end ex1;
