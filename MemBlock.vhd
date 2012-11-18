LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL; 
USE WORK.mem_components.ALL;

ENTITY MemBlock IS
	PORT (	CLK				:	IN	STD_LOGIC;
			RXI,RXO			:	STD_LOGIC_VECTOR (3 DOWNTO 0);
			BUS_IN			: 	INOUT STD_LOGIC_VECTOR (3 DOWNTO 0));
END MemBlock; 

ARCHITECTURE How_To_Mem OF MemBlock IS

SIGNAL R0,R1,R2,R3	:	STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN

reg0: n_register PORT MAP ( BUS_IN, RXI(0), CLK, R0);
reg1: n_register PORT MAP ( BUS_IN, RXI(1), CLK, R1);
reg2: n_register PORT MAP ( BUS_IN, RXI(2), CLK, R2); 
reg3: n_register PORT MAP ( BUS_IN, RXI(3), CLK, R3);
tri0: tri_buf PORT MAP (R0, RXO(0), BUS_IN);
tri1: tri_buf PORT MAP (R1, RXO(1), BUS_IN);
tri2: tri_buf PORT MAP (R2, RXO(2), BUS_IN);
tri3: tri_buf PORT MAP (R3, RXO(3), BUS_IN);

END How_To_Mem; 

