-- 32-bit branch address generator for the RISC321.I datapth.
--
-- Copyright (C) Mazen A. R. Saghir
-- Department of Electrical and Computer Engineering
-- American University of Beirut
-- May 1, 2018
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity branch_addr_gen is
  port (
    i_pc_plus_four : in std_logic_vector (31 downto 0);
    i_immediate : in std_logic_vector (31 downto 0);
    o_branch_addr : out std_logic_vector (31 downto 0)
  );
end branch_addr_gen;

architecture rtl of branch_addr_gen is
  signal w_branch_addr : unsigned (31 downto 0);
  signal w_imm_shift_by_two : std_logic_vector (31 downto 0);
begin
  w_imm_shift_by_two <= i_immediate (30 downto 0) & '0';
  w_branch_addr <= unsigned (i_pc_plus_four) + unsigned (w_imm_shift_by_two);
  o_branch_addr <= std_logic_vector (w_branch_addr);
end rtl;