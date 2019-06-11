-------------------------------------------------------------------------------
--
-- Title       : 
-- Design      : multiplicador
-- Author      : gabigabiguedes@hotmail.com
-- Company     : USP
--
-------------------------------------------------------------------------------
--
-- File        : c:\Users\gabig\Documents\Trabalhos\Org Arq\Coprocessador\multiplicador\compile\registrador.vhd
-- Generated   : Thu Jun  6 15:18:05 2019
-- From        : c:\Users\gabig\Documents\Trabalhos\Org Arq\Coprocessador\multiplicador\src\registrador.bde
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

entity registrador is
  generic(
       NumeroBits : INTEGER := 8;
       Tprop : time := 5 ns;
       Tsetup : time := 2 ns
  );
  port(
       C : in STD_LOGIC;
       R : in STD_LOGIC;
       S : in STD_LOGIC;
       enable : in STD_LOGIC;
       D : in STD_LOGIC_VECTOR(NumeroBits - 1 downto 0);
       Q : out STD_LOGIC_VECTOR(NumeroBits - 1 downto 0)
  );
end registrador;

architecture exo1 of registrador is

---- Signal declarations used on the diagram ----

signal qi : STD_LOGIC_VECTOR(NumeroBits - 1 downto 0);

begin

---- Processes ----

process (C,S,R)
                       begin
                         if R = '1' then
                            qi(NumeroBits - 1 downto 0) <= (others => '0');
                         elsif S = '1' then
                            qi(NUmeroBits - 1 downto 0) <= (others => '1');
                         elsif (C'event and C = '1') then
                            if enable = '1' then
                               if D'last_event < Tsetup then
                                  report "Violação de Set-up time no registrador, valor da saída indefinido = U.";
                                  qi <= (others => 'U');
                               else 
                                  qi <= D;
                               end if;
                            end if;
                         end if;
                       end process;
                      

---- User Signal Assignments ----
Q <= qi after Tprop;

end exo1;
