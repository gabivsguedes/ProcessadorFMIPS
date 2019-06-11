library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity fluxodados is
	port (
	clock,read_enable,reset: in std_logic;	
	--dadocmd: in std_logic_vector(1 downto 0);
	write_enable,write_enable_reg: in std_logic_vector(1 downto 0);
	dado: in std_logic_vector(15 downto 0);
	output : out std_logic_vector(15 downto 0);
	interrupcao,ready,overflow: out std_logic
	);
end fluxodados;

architecture exercicio of  fluxodados is	
component registrador is
  generic(
       NumeroBits : INTEGER := 8;
       Tprop : time := 5 ns;
       Tsetup : time := 2 ns
  );
  port(
       C : in std_logic;
       R : in std_logic;
       S : in std_logic;
	   enable: in std_logic;
       D : in std_logic_vector(NumeroBits - 1 downto 0);
       Q : out std_logic_vector(NumeroBits - 1 downto 0)
  );
end component; 
component raiz is	
	port (			  
		A: in std_logic_vector(15 downto 0);
		clock,enable: in std_logic;	 
		negativo,ready_final: out std_logic;
		S2: out std_logic_vector(15 downto 0)
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
signal ra,sa,rb,sb,rst,sst,rcmd,scmd,re,se : std_logic;
signal saidast: std_logic_vector(31 downto 0); 
signal result_r,result_m,result_final,dadoa,dadob,output_int : std_logic_vector(15 downto 0);
signal saidae,dadoe: std_logic_vector (3 downto 0);
signal enable_m,enable_r,overflow_m,ready_m,ready_r : std_logic;
signal saidacmd: std_logic_vector(1 downto 0);	
signal saidaa,saidab: std_logic_vector(15 downto 0);
signal rest: integer range 0 to 1382146816; 
signal d0,d1,d2,d3: std_logic; 
signal enable_a,enable_b,enable_st,enable_cmd,enable_e,negativo: std_logic; 
signal set_cmd: std_logic_vector(2 downto 0);
signal d_cmd: std_logic_vector(1 downto 0);
begin		
	
	d_cmd<=dado(9 downto 8);
	Rega : registrador generic map( NumeroBits=> 16) port map	(clock,ra,sa,enable_a,dadoa,saidaa); 
	Regb : registrador generic map( NumeroBits=> 16) port map	(clock,rb,sb,enable_b,dadob,saidab); 
	Regst : registrador generic map( NumeroBits=> 16) port map	(clock,rst,sst,enable_st,result_final,output_int);
	Regcmd : registrador generic map( NumeroBits=> 2) port map	(clock,rcmd,scmd,enable_cmd,d_cmd,saidacmd);	
	Rege : registrador generic map( NumeroBits=> 4) port map	(clock,re,se,'1',dadoe,saidae);   
	
	interrupcao<=saidae(3);
	dadoe<=	d3&d2&d1&d0;	
	
	Multiplicador : mult_level1 port map (saidaa,saidab,clock,enable_m,result_m,overflow_m,ready_m);
	Raiz_1 : raiz port map (saidaa,clock,enable_r,negativo,ready_r,result_r);	-- considerando que sempre lê A	
	
	set_cmd<=  enable_cmd&saidacmd;	  
	
	with write_enable_reg select 
	
	dadoa<= dado when "01",  
		  "0000000000000000" when others;	
		   
	with write_enable_reg select
	
	dadob<= dado when "10", 
			"0000000000000000" when others;
	
	with  set_cmd select 
	
	enable_m <= '1' when "001",
				'0' when others;
	
	with set_cmd select 
	
	enable_r <= '1' when "011",
				'0' when others;
	
	with set_cmd select 
	
	result_final <= result_r when "011",
					result_m when "001",
					"0000000000000000" when others;
	output<= output_int;
	with output_int select
	
	d1<= '1' when "0000000000000000",
		'0' when others;
	
	with set_cmd select 
	
	d0 <= '1' when "011",
		  '1' when "001",
		  '1' when "100",
		  '1' when "101",
		  '1' when "110",
		  '1' when "111",
		  '0' when others;
		  
	 with saidacmd select 
	
	 d2<= overflow_m when "01",
	 	  negativo when "11",
		   '0' when others; 
		   
	 with saidacmd select 
	
	 d3<=  ready_m when "01",	
	 	   ready_r when "11",
			'0' when others;
			
	with write_enable_reg select
	
	enable_a<= '1' when "01", 
				'0' when others;
	
	with write_enable_reg select
	
	enable_b<= '1' when "10", 
			   '0' when others;
		 
	with write_enable select
	
	enable_cmd<= '1' when "01", 
			   '0' when others;	
	with saidacmd select
	
	enable_st<= ready_m when "01",--- nao pode perder valor antes da interrupcao
				ready_r when "11",
				'0' when others;
				
	with saidacmd select
	
	ready<= ready_m when "01",--- nao pode perder valor antes da interrupcao
				ready_r when "11",
				'0' when others;
				
	with saidacmd select 
	
	 overflow<= overflow_m when "01",
	 	  negativo when "11",
		   '0' when others; 
	
	
end architecture;