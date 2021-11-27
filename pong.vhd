LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL; 

ENTITY pong IS
GENERIC(N : INTEGER := 17); 
PORT (
	clk : IN STD_LOGIC;
	rst : IN STD_LOGIC;
	VGA_HS, VGA_VS	: OUT STD_LOGIC;
	jugador1  : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	jugador2  : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	VGA_Rojo  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	VGA_Verde : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	VGA_Azul  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	DISPLAY_A : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
	DISPLAY_B : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
);
END ENTITY;


ARCHITECTURE behaviour OF pong IS

SIGNAL clk_vga : STD_LOGIC:='0'; 
SIGNAL reset : STD_LOGIC:='0'; 
SIGNAL nuevo_frame : STD_LOGIC:='0';
SIGNAL iniciar_rojo, iniciar_verde, iniciar_azul : STD_LOGIC_VECTOR(3 DOWNTO 0):= (OTHERS => '0');
SIGNAL deb_sw : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL posicion_horizontal : INTEGER RANGE 0 TO 2256:=0;
SIGNAL posicion_vertical : INTEGER RANGE 0 TO 1087:=0;
SIGNAL jugador1_puntos : INTEGER RANGE 0 TO 10:=0;
SIGNAL jugador2_puntos : INTEGER RANGE 0 TO 10:=0;
SIGNAL TimerMaxTick, ena_timer, sync_clr : STD_LOGIC;
SIGNAL TimerMaxTick1, ena_timer1, sync_clr1 : STD_LOGIC;
CONSTANT Millis5 : UNSIGNED (N-1 DOWNTO 0) := "11110100001001000";

BEGIN
	reset <= NOT rst;
  
pll_clock : ENTITY WORK.pll 
	PORT MAP (
		c0 => clk_vga,
		inclk0 => clk); 
  
jugador1_puntos_display : ENTITY WORK.Display 
	PORT MAP (
	   numero => jugador1_puntos, 
	   SEG7   => DISPLAY_A);
  
jugador2_puntos_display : ENTITY WORK.Display 
	PORT MAP (
	   numero => jugador2_puntos, 
	   SEG7   => DISPLAY_B);
	
vga1 : ENTITY WORK.configuracion_vga 
	PORT MAP (
		clk	 => clk_vga,
		h_syn  => VGA_HS,
		v_syn  => VGA_VS,
		rojo	 => VGA_Rojo,
		verde	 => VGA_Verde,
		azul	 => VGA_Azul,
		nuevo_frame => nuevo_frame,
		horizontal_actual => posicion_horizontal,
		vertical_actual => posicion_vertical,
		rojo_in	 => iniciar_rojo,
		verde_in  => iniciar_verde,
		azul_in	 => iniciar_azul);
 
dibujado_vga : ENTITY WORK.dibujado 
	PORT MAP (
		clk_vga => clk_vga,
		reset  => reset,
		nuevo_frame  => nuevo_frame,
		jugador1	 => jugador1,
		jugador2	 => jugador2,
		posicion_horizontal	 => posicion_horizontal,
		posicion_vertical => posicion_vertical,
		puntos_jugador1 => jugador1_puntos,
		puntos_jugador2 => jugador2_puntos,
		rojo	 => iniciar_rojo,
		verde  => iniciar_verde,
		azul	 => iniciar_azul);
		

END ARCHITECTURE;