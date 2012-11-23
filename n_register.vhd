LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL; 

ENTITY n_register IS
	GENERIC (N:INTEGER :=8);
	PORT (	R		:	IN	STD_LOGIC_VECTOR (N-1 DOWNTO 0);
			Rin,Clk	:	IN	STD_LOGIC; 
			CLR		:	IN 	STD_LOGIC;	
			LOAD	:	IN 	STD_LOGIC;	
			LIV		:	IN	STD_LOGIC_VECTOR (N-1 DOWNTO 0); 
			Q		:	OUT STD_LOGIC_VECTOR (N-1 DOWNTO 0)); 		
END n_register; 

ARCHITECTURE how_to_reg OF n_register IS 

CONSTANT null_SLV		: 	STD_LOGIC_VECTOR (N-1 DOWNTO 0) := (OTHERS => '0');	
	
BEGIN
	PROCESS (Clk)
	BEGIN
		IF RISING_EDGE (Clk) THEN
			IF Rin ='1' THEN
				IF CLR ='1' THEN
					Q<= null_SLV;
				ELSIF LOAD = '1' THEN 
					Q<= LIV; 
				ELSE	
					Q<= R; 
				END IF; 	
			END IF; 
		END IF; 
	END PROCESS;
END how_to_reg; 
