library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity raiz is	
	port (			  
		A: in std_logic_vector(15 downto 0);
		clock,enable: in std_logic;	 
		negativo,ready_final: out std_logic;
		S2: out std_logic_vector(15 downto 0)
	);
end raiz;

--}} End of automatically maintained section

architecture exoo1 of raiz is  
	component raiz_quadrada is
		port (			  
		A, e: in std_logic_vector(15 downto 0);
		clock,enable: in std_logic;
		S: out std_logic_vector(15 downto 0);
		ready1: out std_logic
	);
	end component;	 
	
	component mult_level1 is
		port (
			in_a,in_b: in std_logic_vector(15 downto 0);
			clock,enable: in std_logic;
			result : out std_logic_vector(15 downto 0);
			overflow,ready: out std_logic	
		);
	end component;
	
	signal x0: std_logic_vector(15 downto 0) := "0000000000111000";
	signal x1: std_logic_vector(15 downto 0);
	signal x2: std_logic_vector(15 downto 0); 
	signal x3: std_logic_vector(15 downto 0);	  
	signal x4: std_logic_vector(15 downto 0);	
	signal x5: std_logic_vector(15 downto 0);
	signal x6: std_logic_vector(15 downto 0);
	signal overflow,ready: std_logic;
	signal neg,enabl: std_logic;
	signal ready2: std_logic;
	signal ready3: std_logic;	
	signal ready4: std_logic;	
	signal ready5: std_logic;
	signal ready6: std_logic;  
	
begin								
	
	negativo <= A(15);
	neg <= A(15);
	with neg select
	
	enabl <= enable when '0',
			'0' when '1',
			'0' when others;
	
	
	Raiz1 : raiz_quadrada port map(A, x0, clock, enabl, x1, ready);
	Raiz2 : raiz_quadrada port map(A, x1, clock, ready, x2, ready2);  
	Raiz3 : raiz_quadrada port map(A, x2, clock, ready2, x3, ready3);  
	Raiz4 : raiz_quadrada port map(A, x3, clock, ready3, x4, ready4);	
	Raiz5 : raiz_quadrada port map(A, x4, clock, ready4, x5, ready5);
	Mult : mult_level1 port map(A, x5, clock, ready5, x6, overflow, ready6);
    ready_final <= ready6;
	S2 <= x6;

end architecture;
