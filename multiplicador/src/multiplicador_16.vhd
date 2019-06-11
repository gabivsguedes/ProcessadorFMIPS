library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity multiplicador_16 is
	port (
	in_a,in_b: in std_logic_vector(15 downto 0);
	clock,enable: in std_logic;
	res: out std_logic_vector(32 downto 0);
	ready: out std_logic	
	);
end multiplicador_16;

architecture exo1 of multiplicador_16 is


signal a,b : integer range 0 to 105535;	 
--signal c: integer	range 0 to 1082146816;
signal acabou: std_logic;	
--signal teste : integer range 0 to 32768; 

begin 

	a<= conv_integer(unsigned(in_a));
	b<= conv_integer(unsigned(in_b));	  
	
	process(clock,enable)
	variable size_b : integer range 0 to 105535; 
	variable output : integer range 0 to 1382146816;
	begin 
		if clock'event and clock='1' then
			if enable='1' and acabou /='1' then
				size_b := size_b +1	;
				output:= output + a;
			 	if size_b = b then
					acabou<='1';
					ready<='1';
					res<= conv_std_logic_vector(output,33);	
				elsif b=0 or a=0 then 
					acabou<='1';
					ready<='1';
					res<= conv_std_logic_vector(0,33);	
				else ready <='0';
					 acabou <='0';
				end if;
			else 
				output:= 0;	
				size_b:=0;
				--acabou<='0';
			end if;			
		end if;
	end process;
end architecture;