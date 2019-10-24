library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity TB_Data_Memory is
end TB_Data_Memory;


Architecture beh of TB_Data_Memory is

component data_memory is
  port (
    i_clk : in std_logic;
    i_write_en : in std_logic;
    i_read_en : in std_logic;
    i_addr : in std_logic_vector (31 downto 0);
    i_write_data : in std_logic_vector (31 downto 0);
    o_read_data : out std_logic_vector (31 downto 0)
  );
end component;

signal tb_i_clk  : std_logic := '0';

signal tb_i_addr : std_logic_vector (31 downto 0):= (others => '0');

signal tb_i_write_en : std_logic := '0';
 
signal tb_i_read_en : std_logic := '0';

signal tb_i_write_data : std_logic_vector (31 downto 0):= (others => '0');

signal tb_o_read_data : std_logic_vector (31 downto 0);

begin

UUT: data_memory port map (i_clk	=> tb_i_clk,
			   i_addr       => tb_i_addr , 
			   i_write_en   => tb_i_write_en,
			   i_read_en    => tb_i_read_en,
			   i_write_data => tb_i_write_data,
			   o_read_data  => tb_o_read_data);

clk_process: process
begin
tb_i_clk <= '0';
wait for 50 ns;
tb_i_clk <= '1';
wait for 50 ns;
end process;

stim_process: process
begin
--write to memory
   tb_i_addr		<= x"00000006";
   tb_i_write_data	<= x"11112222"; 
   tb_i_write_en 	<= '0';
   wait for 40 ns;
   tb_i_write_en 	<= '1';
   wait for 40 ns;
   tb_i_write_en 	<= '0';
   wait for 50 ns;

--read to memory
  tb_i_addr		<= x"00000006"; 
  tb_i_read_en 	<= '0';
  wait for 10 ns;
  tb_i_read_en 	<= '1';
  wait for 80 ns;
  tb_i_read_en 	<= '0';
  wait for 40 ns;
 
end process;
end beh;
