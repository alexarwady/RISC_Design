library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity muxlike is
port( i_instr : in std_logic_vector (31 downto 0);
input1 : in std_logic_vector (31 downto 0);
input2 : in std_logic_vector (31 downto 0);
output : out std_logic_vector(31 downto 0));
end muxlike;

architecture rtl of muxlike is
begin
process (i_instr, input1, input2)
begin
if(i_instr(6 downto 0) = "1101111") then
output <= input2;
else output <= input1;
end if;
end process;
end rtl;
