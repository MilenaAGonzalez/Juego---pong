LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL; 

ENTITY dibujado IS 
PORT (
   clk_vga	: IN STD_LOGIC;
	reset  	: IN STD_LOGIC;
	nuevo_frame	: IN STD_LOGIC;
	jugador1	: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	jugador2	: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	posicion_horizontal : IN INTEGER RANGE 0 TO 2256;
	posicion_vertical   : IN INTEGER RANGE 0 TO 1087;
	puntos_jugador1	  : OUT INTEGER RANGE 0 TO 10;
	puntos_jugador2	  : OUT INTEGER RANGE 0 TO 10;
	rojo	: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	verde	: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	azul	: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
);
END ENTITY;
 
ARCHITECTURE behaviour OF dibujado IS
CONSTANT velocidad_paleta : INTEGER := 5;
CONSTANT velocidad_bola_defecto : INTEGER := 5;
SIGNAL iniciar_rojo, iniciar_verde, iniciar_azul : STD_LOGIC_VECTOR(3 DOWNTO 0):= (OTHERS => '0');
SIGNAL paleta_horizontal1 : INTEGER RANGE 586 TO 2246:= 620;
SIGNAL paleta_vertical1 : INTEGER RANGE 47 TO 1077:= 515;
SIGNAL paleta_horizontal2 : INTEGER RANGE 586 TO 2246:= 2197;
SIGNAL paleta_vertical2 : INTEGER RANGE 47 TO 1077:= 512;
SIGNAL posicion_bola_h1 : INTEGER RANGE 586 TO 2246:= 1500;
SIGNAL posicion_bola_v1 : INTEGER RANGE 47 TO 1077:= 515;
SIGNAL bola_up	: STD_LOGIC:= '0';
SIGNAL bola_D	: STD_LOGIC:= '1';
SIGNAL velocidad_bola_h : INTEGER RANGE 0 TO 15:= velocidad_bola_defecto;
SIGNAL velocidad_bola_v	: INTEGER RANGE 0 TO 15:= velocidad_bola_defecto;
SIGNAL jugador1_puntos : INTEGER RANGE 0 TO 10:=0;
SIGNAL jugador2_puntos : INTEGER RANGE 0 TO 10:=0;
SIGNAL ganador_jugador1 : STD_LOGIC := '0';
SIGNAL ganador_jugador2 : STD_LOGIC := '0';

BEGIN
rojo <= iniciar_rojo;
verde <= iniciar_verde;
azul <= iniciar_azul;
puntos_jugador1 <= jugador1_puntos;
puntos_jugador2 <= jugador2_puntos;
dibujado_paleta : PROCESS (clk_vga) 
BEGIN
	IF(RISING_EDGE(clk_vga)) THEN
		IF((posicion_horizontal >= paleta_horizontal1 AND posicion_horizontal < paleta_horizontal1 + 15) AND (posicion_vertical >= paleta_vertical1 AND posicion_vertical < paleta_vertical1 + 80) ) THEN
		 IF(ganador_jugador1 = '0') THEN
			iniciar_verde <= X"F";
		 ELSE
		   iniciar_azul <= X"F";
		 END IF;
		ELSIF((posicion_horizontal >= paleta_horizontal2 AND posicion_horizontal < paleta_horizontal2 + 15) AND (posicion_vertical >= paleta_vertical2 AND posicion_vertical < paleta_vertical2 + 80) ) THEN
		 IF(ganador_jugador2 = '0') THEN
			iniciar_verde <= X"F";
		 ELSE
		   iniciar_azul <= X"F";
		 END IF;
		ELSE
			iniciar_verde <= X"0";
			iniciar_azul <= X"0";
		END IF;	
	END IF;	 
END PROCESS;

dibujado_bola : PROCESS (clk_vga) 
BEGIN 
	IF(RISING_EDGE(clk_vga)) THEN
		IF((posicion_horizontal >= posicion_bola_h1 AND posicion_horizontal < posicion_bola_h1 + 15) AND (posicion_vertical >= posicion_bola_v1 AND posicion_vertical < posicion_bola_v1 + 15) ) THEN
			iniciar_rojo <= X"F";
		ELSE
			iniciar_rojo <= X"0";
		END IF;
	END IF; 
END PROCESS;

mover_paleta : PROCESS (clk_vga) 
BEGIN
	IF (RISING_EDGE(clk_vga) AND nuevo_frame = '1') THEN	
		IF(jugador2(0) = '0') THEN  
			IF(paleta_vertical2 < 997) THEN
				paleta_vertical2 <= paleta_vertical2 + velocidad_paleta;
			ELSE
				paleta_vertical2 <= paleta_vertical2;		
			END IF;
		ELSIF(jugador2(1) = '0') THEN  
			IF (paleta_vertical2 > 47) THEN
				paleta_vertical2 <= paleta_vertical2 - velocidad_paleta;
			ELSE
				paleta_vertical2 <= paleta_vertical2; 
			END IF;
		END IF;		

		IF(jugador1(0) = '0') THEN
			IF(paleta_vertical1 < 997) THEN
				paleta_vertical1 <= paleta_vertical1 + velocidad_paleta;
			ELSE
				paleta_vertical1 <= paleta_vertical1;
			END IF;
		ELSIF(jugador1(1) = '0') THEN
			IF(paleta_vertical1 > 47) THEN
				paleta_vertical1 <= paleta_vertical1 - velocidad_paleta;
			ELSE
				paleta_vertical1 <= paleta_vertical1;
			END IF;
		END IF;		
	END IF;	 
END PROCESS;

mover_bola : PROCESS(clk_vga) 
BEGIN
	IF(RISING_EDGE(clk_vga) AND nuevo_frame = '1') THEN
		IF(reset = '1') THEN
		   ganador_jugador1 <= '0';
			ganador_jugador2 <= '0';
			jugador2_puntos <= 0;
			jugador1_puntos <= 0;
			posicion_bola_v1 <= 515;
			posicion_bola_h1 <= 1500;
			velocidad_bola_h <= velocidad_bola_defecto;
			velocidad_bola_v <= velocidad_bola_defecto;
		ELSE
			IF(posicion_bola_v1 < 1062 AND bola_up = '1') THEN
				posicion_bola_v1 <= posicion_bola_v1 + velocidad_bola_v;
			ELSIF (bola_up = '1') THEN
				bola_up <= '0';
			ELSIF (posicion_bola_v1 >47 AND bola_up = '0') THEN
				posicion_bola_v1 <= posicion_bola_v1 - velocidad_bola_v;
			ELSIF (bola_up = '0') THEN
				bola_up <= '1';
			END IF;		
			IF(posicion_bola_h1 < 2231 AND bola_D = '1') THEN
				posicion_bola_h1 <= posicion_bola_h1 + velocidad_bola_h;
			ELSIF (bola_D = '1') THEN
				bola_D	<= '0';						
				IF(jugador2_puntos  < 9) THEN
				   ganador_jugador1 <= '0';
					ganador_jugador2 <= '0';
					jugador2_puntos <= jugador2_puntos + 1;
					posicion_bola_v1 <= 515;
					posicion_bola_h1 <= 1500;
				ELSE	
				   ganador_jugador1 <= '0';
					ganador_jugador2 <= '1';
					velocidad_bola_h <= 0;
					velocidad_bola_v <= 0;
				END IF;				
			ELSIF(posicion_bola_h1 >586 AND bola_D = '0') THEN
				posicion_bola_h1 <= posicion_bola_h1 - velocidad_bola_h;
			ELSIF(bola_D = '0') THEN
				bola_D <= '1';			
				IF(jugador1_puntos < 9) THEN
				   ganador_jugador1 <= '0';
					ganador_jugador2 <= '0';
					jugador1_puntos <= jugador1_puntos + 1;
					posicion_bola_v1 <= 515;
					posicion_bola_h1 <= 1500;
				ELSE	
				   ganador_jugador1 <= '1';
					ganador_jugador2 <= '0';
					velocidad_bola_h <= 0;
					velocidad_bola_v <= 0;
				END IF;
			END IF;
		END IF;
	
	ELSIF RISING_EDGE(clk_vga) THEN
		IF(iniciar_verde = X"F" AND iniciar_rojo = X"F") THEN
			bola_D <= bola_D XOR '1';
		END IF;			
	END IF;		 
END PROCESS;
END ARCHITECTURE;