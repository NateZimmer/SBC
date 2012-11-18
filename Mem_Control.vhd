--Nathan Zimmerman
--Lower Level Memory Control Unit


LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL; 

ENTITY Mem_Control IS 
	PORT (	Clk,Rst		:	IN	STD_LOGIC;
			CNTRL		:	IN	STD_LOGIC_VECTOR (2 DOWNTO 0); 
			LIV,RI, RO	:	IN	STD_LOGIC_VECTOR (3 DOWNTO 0);
			Bus_In		:	INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			STATE		:	OUT	STD_LOGIC_VECTOR (1 DOWNTO 0);
			R			:	BUFFER STD_LOGIC);

END Mem_Control;

ARCHITECTURE How_To_Control OF Mem_Control IS

COMPONENT MemBlock IS
	PORT (	CLK				:	IN	STD_LOGIC;
			RXI,RXO			:	STD_LOGIC_VECTOR (3 DOWNTO 0);
			BUS_IN			: 	INOUT STD_LOGIC_VECTOR (3 DOWNTO 0));
				
END COMPONENT; 

TYPE State_type IS (A, B); 
SIGNAL y: State_type :=A; 

SIGNAL RIN	:	STD_LOGIC_VECTOR (3 DOWNTO 0 ); 
SIGNAL ROUT	:	STD_LOGIC_VECTOR (3 DOWNTO 0 );
SIGNAL Sate_Num : STD_LOGIC_VECTOR (1 DOWNTO 0);

BEGIN
	PROCESS	(Rst,Clk)
	BEGIN
		IF Rst = '0' THEN
		y<= A;
		RIN 	<= "0000"; --TURNOFF inputs
		ROUT	<= "0000"; --TURNOFF outputs
		R <= '0'; 
		Sate_Num <= "00"; 
		
		ELSIF RISING_EDGE (Clk) THEN
			CASE CNTRL IS
				WHEN "001" =>
					CASE y IS
						WHEN A =>
							RIN <=RI; 
							ROUT <="0000";
							R <= '0'; 
							y <=B;
							Sate_Num <= "01"; 
						WHEN B =>
							R <='1';
							RIN <="0000";
							ROUT <="0000";
							Sate_Num <= "10";  
					END CASE;
				WHEN "010" =>
					CASE y IS
						WHEN A =>
							R <= '0';
							RIN <=RO;
							ROUT <= RI;
							y <= B;
							Sate_Num <= "01";
						WHEN B =>
							R <='1';
							RIN <="0000";
							ROUT <="0000";
							Sate_Num <= "10";
					END CASE; 		
				WHEN OTHERS =>
					R<='0'; 
					RIN <="0000";
					ROUT <="0000";
			END CASE;
		END IF;
	END PROCESS;
	
	Memmory: MemBlock PORT MAP(CLK,RIN,ROUT,BUS_IN ); 
	Memmory2: BUS_IN <= LIV WHEN CNTRL ="001" ELSE
						(OTHERS =>'Z');
	STATE <= Sate_Num;
	  
END How_To_Control;

			 