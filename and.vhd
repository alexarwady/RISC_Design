
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity andblock is
port( input1 : in std_logic;
input2 : in std_logic;
input3 : in std_logic;
i_instr : in std_logic_vector (31 downto 0);
output : out std_logic);
end andblock;

architecture rtl of andblock is
begin
process(input1, input2, input3, i_instr)
begin
if (i_instr(6 downto 0) = "1100011" and i_instr(14 downto 12) = "000") then --beq
output <= input2 and input1;
elsif (i_instr(6 downto 0) = "1100011" and i_instr(14 downto 12) = "100") then --blt
output <= input2 and input3;
else output <= '0';
end if;
end process;
end rtl;