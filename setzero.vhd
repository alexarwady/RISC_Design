library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity setzero is
port (
i_inst: in std_logic_vector (31 downto 0);
i_imm: in std_logic_vector (31 downto 0);
o_imm: out std_logic_vector (31 downto 0)
);
end setzero;

architecture rtl of setzero is
begin
process (i_inst, i_imm)
begin
if (i_inst(6 downto 0) = "1100111") then
o_imm <= i_imm(31 downto 1) & '0';
else 
o_imm <= i_imm(31 downto 0);
end if;
end process;
end rtl;
