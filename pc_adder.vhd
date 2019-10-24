-- 32-bit PC adder for the RISC321.I datapth.
--
-- Copyright (C) Mazen A. R. Saghir
-- Department of Electrical and Computer Engineering
-- American University of Beirut
-- May 1, 2018
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_adder is
  port (
    i_pc : in std_logic_vector (31 downto 0);
    o_pc_plus_four : out std_logic_vector (31 downto 0)
  );
end pc_adder;

architecture rtl of pc_adder is
  signal w_pc_plus_four : integer;
begin
  w_pc_plus_four <= to_integer(unsigned(i_pc)) + 4;
  o_pc_plus_four <= std_logic_vector(to_signed(w_pc_plus_four,32));
end rtl;