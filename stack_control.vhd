LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL; 

ENTITY stack_control IS
	GENERIC (N : INTEGER := 8);
	PORT (	LIV		:	IN	STD_LOGIC_VECTOR (N -1 : DOWNTO 0); --
			CNTRL	:	IN	STD_LOGIC_VECTOR (2 DOWNTO 0); --3bits for controls
			ENTER	:	IN	STD_LOGIC;
			CMD		:	IN	STD_LOGIC; 
			CLK		:	IN 	STD_LOGIC
			Stack_top	:	OUT	STD_LOGIC_VECTOR (3 : DOWNTO 0);
			ERROR		:	OUT STD_LOGIC; 
			OVER_FLOW	:	OUT STD_LOGIC;
			BUS_IN		:	INOUT STD_LOGIC_VECTOR (N-1 : DOWNTO 0);
			RST			:	IN	STD_LOGIC  		
	); 
	
END stack_control;

ARCHITECTURE how_to_stack OF stack_control IS

COMPONENT mem_control IS
	GENERIC (N : INTEGER := 8); 
	PORT (	Clk,Rst		:	IN	STD_LOGIC;
			CNTRL		:	IN	STD_LOGIC_VECTOR (2 DOWNTO 0); 
			Z1, Z2		:	IN	STD_LOGIC_VECTOR (3 DOWNTO 0);
			LIV			:	IN	STD_LOGIC_VECTOR (N-1 DOWNTO 0); 
			Bus_In		:	INOUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			STATE		:	OUT	STD_LOGIC_VECTOR (1 DOWNTO 0);
			R			:	BUFFER STD_LOGIC);
END COMPONENT; 

SIGNAL Internal_STK_PTR : STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL Internal_RST		: STD_LOGIC := '0'; 
SIGNAL Internal_CNTRL	: STD_LOGIC_VECTOR (2 DOWNTO 0); 
SIGNAL Internal_Z1		: STD_LOGIC_VECTOR (3 DOWNTO 0); 
SIGNAL Internal_Z2		: STD_LOGIC_VECTOR (3 DOWNTO 0); 
SIGNAL Internal_LIV		: STD_LOGIC_VECTOR (N-1 DOWNTO 0); 
SIGNAL Internal_State	: STD_LOGIC_VECTOR (1 DOWNTO 0); 
SIGNAL Internal_Ready	: STD_LOGIC; 



PROCESS (ENTER,CMD, CLK)
	
	IF
	ELSIF RISING_EDGE (Clk)	
		ELSIF ENTER = '1' THEN -- Depends on active low/high
			IF Internal_STK_PTR="1111" THEN -- Report Stack Overflow 
				ERROR <= '1'; 
			ELSIF Internal_STK_PTR ="0000" THEN -- Load value into R0
				CASE y IS
					WHEN A =>
						IF Internal_Ready ='0' THEN
							Internal_CNTRL => "001"; -- Load Command
							Internal_Z1 => "0001"; --Move into Reg 1 
							Internal_z2 => "0000"; -- Don't care
							y => A; 							
						ELSE
							y => B;
							Internal_CNTRL => "000"; -- Load Command
							Internal_Z1 => "0000"; --Move into Reg 1 
							Internal_z2 => "0000"; -- Don't care							
						END IF;
						 
					
					
					
					Internal_RST => '0';
					y =>B;  
					WHEN B => 
					Internal_RST => '1'; 
					y =>C; 
					WHEN C=>


					Internal_LIV => LIV; 
					
					


			ELSIF Internal_STK_PTR ="0001" THEN -- Load value into R1
			
			ELSIF Internal_STK_PTR ="0011" THEN -- Load value into R2
			
			ELSIF Internal_STK_PTR ="0111" THEN -- Load value into R3
			
			END IF; 
			
		ELSIF CMD = '1' THEN
		
		END IF; 
	END IF; 
END PROCESS; 

Mem_con: mem_control PORT MAP (CLK,Internal_RST,Internal_CNTRL,Internal_Z1,INTERNAL_Z2, Internal_LIV, BUS_IN, Internal_State, Internal_Ready );  






BEGIN 


END how_to_stack; 


