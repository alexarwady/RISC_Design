library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux is
port( control : in std_logic;
input1 : in std_logic_vector (31 downto 0);
input2 : in std_logic_vector (31 downto 0);
output : out std_logic_vector(31 downto 0));
end mux;

architecture rtl of mux is
begin
process (control, input1, input2)
begin
case control is
when '0' => output <= input1;
when '1' => output <= input2;
when others => output <= (others => '0');
end case;
end process;
end rtl;