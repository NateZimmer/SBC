--Nathan Zimmerman
--Lower Level Memory Control Unit


LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL; 

ENTITY Mem_Control IS 
	GENERIC (N : INTEGER := 8); 
	PORT (	Clk,Rst		:	IN	STD_LOGIC;
			CNTRL		:	IN	STD_LOGIC_VECTOR (2 DOWNTO 0); 
			Z1, Z2		:	IN	STD_LOGIC_VECTOR (3 DOWNTO 0);
			LIV			:	IN	STD_LOGIC_VECTOR (N-1 DOWNTO 0); 
			Bus_In		:	INOUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			STATE		:	OUT	STD_LOGIC_VECTOR (1 DOWNTO 0);
			R			:	BUFFER STD_LOGIC);

END Mem_Control;

ARCHITECTURE How_To_Control OF Mem_Control IS

COMPONENT MemBlock IS
	PORT (	CLK,CLR,LOAD	:	IN	STD_LOGIC;
			RXI,RXO			:	IN STD_LOGIC_VECTOR (3 DOWNTO 0); --Not 8 cause we have 4 regs
			LIV				:	IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
			BUS_IN			: 	INOUT STD_LOGIC_VECTOR (N-1 DOWNTO 0));				
END COMPONENT; 

TYPE State_type IS (A, B); 
SIGNAL y: State_type :=A; 

SIGNAL RIN				:	STD_LOGIC_VECTOR (3 DOWNTO 0 ); 
SIGNAL ROUT				:	STD_LOGIC_VECTOR (3 DOWNTO 0 );
SIGNAL State_Num 		: 	STD_LOGIC_VECTOR (1 DOWNTO 0);
SIGNAL CLR				:	STD_LOGIC := '0';
SIGNAL LOAD				:	STD_LOGIC := '0';

CONSTANT null_SLV		: 	STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0');


BEGIN
	PROCESS	(Rst,Clk)
	BEGIN
		IF Rst = '0' THEN
		y<= A;
		RIN 	<=  null_SLV; --TURNOFF inputs
		ROUT	<=  null_SLV; --TURNOFF outputs
		R <= '0'; 
		CLR <= '0';
		LOAD <= '0'; 
		State_Num <= "00"; 
		
		ELSIF RISING_EDGE (Clk) THEN
			CASE CNTRL IS
				WHEN "001" => -- Move LIV into Z1
					CASE y IS
						WHEN A =>
							RIN <=Z1; 
							ROUT <= null_SLV; --TURNOFF outputs
							R <= '0'; --Not Done
							LOAD <= '1'; -- Tell mem block to load in our value 
							CLR <= '0';
							State_Num <= "01";   
							y <=B; --Next State is B
						WHEN B =>
							R <='1';	--CLR bus, assert done bit
							RIN <= null_SLV;
							ROUT <= null_SLV;
							State_Num <= "10";
							LOAD <= '0';
							CLR <= '0';  
					END CASE;
				WHEN "010" => -- Move Z1 into Z2
					CASE y IS
						WHEN A =>
							R <= '0';
							ROUT <= Z1; --Move Z1 out onto the bus
							RIN <=Z2; -- Take bus and move it into Z2
							y <= B;
							State_Num <= "01";
							CLR <= '0';
							LOAD <= '0';
						WHEN B =>
							R <='1';
							ROUT <= Z1; --Move Z1 out onto the bus
							RIN <=Z2; -- Take bus and move it into Z2
							State_Num <= "10";
							LOAD <= '0';
							CLR <= '0'; 							
					END CASE;
				WHEN "011" => -- Move Z1 to bus
					CASE y IS
						WHEN A =>
							R <= '0';
							RIN <=  null_SLV; --Do not output anything to bus
							ROUT <= Z1; 
							State_Num <="01";
							y <= B;
							CLR <= '0';
							LOAD <= '0';							
						WHEN B => 
							R <= '1';
							RIN <=  null_SLV; --Do not output anything to bus
							ROUT <= Z1; 
							State_Num <="10";
							LOAD <= '0';
							CLR <= '0'; 							
					END CASE;
				WHEN "100" => -- MOV BUS INTO Z1
					CASE y IS
						WHEN A =>
							R <= '0'; 
							RIN <=Z1; 
							ROUT <= null_SLV; 
							State_Num <="01";
							y <= B; 
							CLR <= '0';
							LOAD <= '0';							
						WHEN B =>
							R <= '1';
							RIN <=Z1; 
							ROUT <= null_SLV; 
							State_Num <="10";
							LOAD <= '0';
							CLR <= '0'; 							
					END CASE;	
				WHEN "101" => --CLR REGS	
					CASE y IS
						WHEN A =>					
							R <= '0'; 
							RIN <="1111"; --All Regs selected
							CLR <= '1';	--CLR Regs					 
							ROUT <= null_SLV; 
							State_Num <="01";
							y <= B; 
						WHEN B =>
							R <= '1';
							RIN <=null_SLV; 
							ROUT <= null_SLV; 
							State_Num <="10";
							LOAD <= '0';
							CLR <= '0';
					END CASE; 				
				WHEN OTHERS =>
					R<='0'; 
					RIN <= null_SLV;
					ROUT <= null_SLV;
					LOAD <= '0';
					CLR <= '0'; 
					State_Num <= "11";					
			END CASE;
		END IF;
	END PROCESS;
	
	Memmory: MemBlock PORT MAP(CLK,CLR,LOAD,RIN,ROUT,LIV,BUS_IN ); 
	STATE <= State_Num;
	  
END How_To_Control;

			 