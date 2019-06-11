library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity mult_level2 is
	port (
	in_a,in_b: in std_logic_vector(15 downto 0);
	clock,enable: in std_logic;
	result : out std_logic_vector(15 downto 0);
	overflow,ready: out std_logic	
	);
end mult_level2;

architecture ex1 of mult_level2 is	 

component multiplicador_16 is
	port (
	in_a,in_b: in std_logic_vector(15 downto 0);
	clock,enable: in std_logic;
	res : out std_logic_vector(32 downto 0);
	ready: out std_logic	
	);
end component;

signal acabou: std_logic;	
signal sinal : std_logic_vector(1 downto 0);
signal inta,intb,a,b,res_int: std_logic_vector(15 downto 0);		 
signal res: std_logic_vector(32 downto 0);
signal res_int1 : std_logic_vector(15 downto 0);

begin

	sinal<= in_a(15)& in_b(15);
	inta<= not(in_a);
	intb<= not(in_b);
	with sinal select
	
	a<=	    conv_std_logic_vector(conv_integer(unsigned(in_a)),16) when "00",
			conv_std_logic_vector(conv_integer(unsigned(in_a)),16) when "01",
			conv_std_logic_vector(conv_integer(unsigned(inta))+1,16) when "10",
			conv_std_logic_vector(conv_integer(unsigned(inta))+1,16) when "11",
			"0000000000000000" when others;
			
	with sinal select
	
	b<=	    conv_std_logic_vector(conv_integer(unsigned(in_b)),16) when "00",
			conv_std_logic_vector(conv_integer(unsigned(intb))+1,16) when "01",
			conv_std_logic_vector(conv_integer(unsigned(in_b)),16) when "10",
			conv_std_logic_vector(conv_integer(unsigned(intb))+1,16) when "11",
			"0000000000000000" when others; 
	
			
	Multiplicador : multiplicador_16 port map(a,b,clock,enable,res,acabou);	
	overflow <= res(32);
	
	res_int1 <= res(23 downto 8);
	with sinal select
	
	result<=	    res_int1 when "00",
					conv_std_logic_vector(conv_integer(unsigned(not(res_int1)))+1,16)when "01",
					conv_std_logic_vector(conv_integer(unsigned(not(res_int1)))+1,16) when "10",
					res_int1 when "11",
					"0000000000000000" when others;
	process(acabou)
	begin
		if acabou'event and acabou='1' then
			ready<='1';
		else ready<='0'; 
		end if;
	end process;
			
end architecture;