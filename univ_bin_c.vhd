LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;	 

ENTITY univ_bin_c is
PORT(
 clk: IN STD_LOGIC; 
 slow_clk_enable: OUT STD_LOGIC
);
END ENTITY;

ARCHITECTURE Behavioral OF univ_bin_c IS
SIGNAL counter: STD_LOGIC_VECTOR(27 DOWNTO 0):=(OTHERS => '0');
BEGIN
PROCESS(clk)
BEGIN
IF(RISING_EDGE(clk)) THEN
  counter <= counter + x"0000001"; 
  IF(counter>=x"003D08F") THEN 
   counter <=  (OTHERS => '0');
  END IF;
 END IF;
END PROCESS;
 slow_clk_enable <= '1' WHEN counter=x"003D08F" ELSE '0';
END ARCHITECTURE;