library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity unidade_controle_copro is
	port(
	clock: in std_logic;
	enable_uc,reset: in std_logic;
	rw : in std_logic_vector(3 downto 0);
	dado : in std_logic_vector(15 downto 0);
	output : out std_logic_vector (15 downto 0);
	ready,interrupcao,overflow: out std_logic
	
	);
end unidade_controle_copro;

architecture exe1 of unidade_controle_copro is

component fluxodados is
	port (
	clock,read_enable,reset: in std_logic;	
	--dadocmd: in std_logic_vector(1 downto 0);
	write_enable,write_enable_reg: in std_logic_vector(1 downto 0);
	dado: in std_logic_vector(15 downto 0);
	output : out std_logic_vector(15 downto 0);
	interrupcao,ready,overflow: out std_logic
	);
end component;
 
type estados is (espera,loadA,loadB,loadCmd,uma_espera,ocupado);
signal z: estados;
signal ready_f,read_e,enable_int,over : std_logic;
signal write_e, write_enable_r: std_logic_vector(1 downto 0); 

begin 
	
	enable_int <= enable_uc; 
	
	process(clock)
	begin 
		if enable_uc ='0' then
			z<=espera; 
			write_e<= "00";
			write_enable_r <= "00";
			read_e<= '0';
			
		elsif clock'event and clock='1' then
			if  enable_uc='1' then
				case z is  
					when espera => 
						z<=loadA; 
						write_e<= "00";
						write_enable_r <= "01";
						read_e<= '0';
						
				  	when  loadA =>
					  	z<= loadB;
						write_e<= "00";
						write_enable_r <= "10";
						read_e<= '0';
						
					  	
					when loadB =>
					 	z<= loadCmd;
						write_e<= "01";
						write_enable_r <= "00";
						read_e<= '0'; 	 
						
					when loadCmd =>
						z<= ocupado;
						write_e<= "00";
						write_enable_r <= "00";
						read_e<= '0'; 
						
					when ocupado => 
						
						write_e<= "00";
						write_enable_r <= "00";
						read_e<= '0';  
						
						if ready_f='1' or over = '1' then
							z<= uma_espera;
						else z<= ocupado;
						end if;
					when uma_espera =>
						write_e<= "00";
						write_e <= "00";
						read_e<= '0';
						
					end case; 
				end if;
		  end if;
	end process;	
	ready<=ready_f;
	overflow <= over;
	FluxoDeDados : fluxodados port map (clock,read_e,reset,write_e,write_enable_r,dado,output,interrupcao,ready_f,over); 
	
end architecture;