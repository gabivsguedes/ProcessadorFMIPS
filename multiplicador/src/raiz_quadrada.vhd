library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity raiz_quadrada is
	port (			  
		A, e: in std_logic_vector(15 downto 0);
		clock,enable: in std_logic;
		S: out std_logic_vector(15 downto 0);
		ready1: out std_logic
	);
end raiz_quadrada;

architecture exo1 of raiz_quadrada is		 

	component mult_level1 is
		port (
			in_a,in_b: in std_logic_vector(15 downto 0);
			clock,enable: in std_logic;
			result : out std_logic_vector(15 downto 0);
			overflow,ready: out std_logic	
		);
	end component;

signal x_0: std_logic_vector(15 downto 0);
signal x_0_2: std_logic_vector(15 downto 0);
signal aux: std_logic_vector(15 downto 0);
signal X: std_logic_vector(15 downto 0);
signal res: std_logic_vector(15 downto 0);	
signal res2: std_logic_vector(15 downto 0);	  
signal res3: std_logic_vector(15 downto 0);
signal res4: std_logic_vector(15 downto 0);
signal overflow: std_logic;
signal ready: std_logic;  
signal ready2: std_logic; 
signal ready3: std_logic;
signal enable2: std_logic := '0';
signal error: std_logic_vector(15 downto 0) := "0000000100000000";

begin  
	
	x_0 <= e; 
	x_0_2 <= "0" & x_0(15 downto 1);
	aux <= x_0;
	
	X <= A;
	
	Mult1 : mult_level1 port map(x_0, aux, clock, enable, res, overflow, ready);
	Mult2 : mult_level1 port map(X, res, clock, ready, res2, overflow, ready2);
	Mult3 : mult_level1 port map(x_0_2, res3, clock, enable2, res4, overflow, ready3);
	
	process(res2)
	begin
		if ready2='1' then 
			res3 <= conv_std_logic_vector(768 - conv_integer(unsigned(res2)),16);
			enable2 <= '1';
		end if;									  
	end process;	 
	process(res4)
	begin
		if ready3='1' then
			error <= conv_std_logic_vector(conv_integer(unsigned(res4)) - conv_integer(unsigned(x_0)),16);
			-- x_0 <= res4;
			ready1 <= '1';
		end if;
	end process;
	
	S <= res4;

end architecture;