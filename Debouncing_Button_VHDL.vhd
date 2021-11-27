LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Debouncing_Button_VHDL IS
PORT(
 button: IN STD_LOGIC;
 clk: IN STD_LOGIC;
 debounced_button: OUT STD_LOGIC
);
END ENTITY;

ARCHITECTURE Behavioral OF Debouncing_Button_VHDL IS
SIGNAL slow_clk_enable: STD_LOGIC;
SIGNAL boton: STD_LOGIC;
SIGNAL Q1,Q2,Q2_bar,Q0: STD_LOGIC;
BEGIN

boton <= NOT button;

clock_enable_generator: ENTITY WORK.univ_bin_c PORT MAP 
      ( clk => clk,
        slow_clk_enable => slow_clk_enable
      );
Debouncing_FF0: ENTITY WORK.antirebote PORT MAP 
      ( clk => clk,
        clock_enable => slow_clk_enable,
        D => boton,
        Q => Q0
      ); 

Debouncing_FF1: ENTITY WORK.antirebote PORT MAP 
      ( clk => clk,
        clock_enable => slow_clk_enable,
        D => Q0,
        Q => Q1
      );      
Debouncing_FF2: ENTITY WORK.antirebote PORT MAP 
      ( clk => clk,
        clock_enable => slow_clk_enable,
        D => Q1,
        Q => Q2
      ); 
 Q2_bar <= NOT Q2;
 debounced_button <= Q1 AND Q2_bar;
END ARCHITECTURE;