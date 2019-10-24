library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
  port (
    i_clk : in std_logic;
    i_write_en : in std_logic;
    i_read_reg_1 : in std_logic_vector (4 downto 0);
    i_read_reg_2 : in std_logic_vector (4 downto 0);
    i_write_reg : in std_logic_vector (4 downto 0);
    i_write_data : in std_logic_vector (31 downto 0);
    o_read_data_1 : out std_logic_vector (31 downto 0);
    o_read_data_2 : out std_logic_vector (31 downto 0)
  );
end register_file;

architecture rtl of register_file is

type reg_file is array (0 to 31) of
std_logic_vector (31 downto 0);

signal reg_array : reg_file := ( x"00000000", --$zero
				 x"ffffffff", --$ra
				 x"7ffff1ec", --$sp
				 x"10008000", --$gp
				 x"11111111", --$tp
				 x"00000000", --$t0
				 x"11111111", --$t1
				 x"22222222", --$t2
				 x"00000000", --$s0/fp
				 x"11111111", --$s1
				 x"00000000", --$a0
				 x"11111111", --$a1
				 x"22222222", --$a2
				 x"33333333", --$a3
				 x"44444444", --$a4
				 x"55555555", --$a5
				 x"66666666", --$a6
				 x"77777777", --$a7
				 x"22222222", --$s2
				 x"33333333", --$s3
				 x"44444444", --$s4
				 x"55555555", --$s5
				 x"66666666", --$s6
				 x"77777777", --$s7
				 x"88888888", --$s8
				 x"99999999", --$s9
				 x"aaaaaaaa", --$s10
				 x"bbbbbbbb", --$s11
				 x"33333333", --$t3
				 x"44444444", --$t4
				 x"55555555", --$t5
				 x"66666666"); --$t6
				

begin

process(i_write_en, i_clk, i_read_reg_1, i_read_reg_2, reg_array, i_write_reg, i_write_data)
begin

if(i_clk'event and i_clk = '1') then
if(i_write_en = '1') then
reg_array(to_integer(unsigned(i_write_reg))) <= i_write_data;
end if;
end if;

if(i_clk = '0') then
o_read_data_1 <= reg_array(to_integer(unsigned(i_read_reg_1)));
o_read_data_2 <= reg_array(to_integer(unsigned(i_read_reg_2)));
end if;

end process;
end rtl;

