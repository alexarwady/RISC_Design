library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file_tb is
end register_file_tb;

architecture behavior of register_file_tb is

--component declaration
component register_file
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
end component;

--Inputs
signal tb_i_clk : std_logic := '0';
signal tb_i_write_en : std_logic := '0';
signal tb_i_read_reg_1 : std_logic_vector (4 downto 0) := (others => '0');
signal tb_i_read_reg_2 : std_logic_vector (4 downto 0) := (others => '0');
signal tb_i_write_reg : std_logic_vector (4 downto 0) := (others => '0');
signal tb_i_write_data : std_logic_vector (31 downto 0) := (others => '0');

--Outputs
signal tb_o_read_data_1 : std_logic_vector (31 downto 0);
signal tb_o_read_data_2 : std_logic_vector (31 downto 0);

begin

uut: register_file port map (
    i_clk => tb_i_clk,
    i_write_en => tb_i_write_en,
    i_read_reg_1 => tb_i_read_reg_1,
    i_read_reg_2 => tb_i_read_reg_2,
    i_write_reg => tb_i_write_reg,
    i_write_data => tb_i_write_data, 
    o_read_data_1 => tb_o_read_data_1,
    o_read_data_2 => tb_o_read_data_2);

clk_process: process
begin
tb_i_clk <= '0';
wait for 50 ns;
tb_i_clk <= '1';
wait for 50 ns;
end process;

stim_process: process
begin
tb_i_write_en <= '0';
for i in 0 to 30 loop
tb_i_read_reg_1 <= std_logic_vector(to_unsigned(i,5));
tb_i_read_reg_2 <= std_logic_vector(to_unsigned(i+1,5));
wait for 50 ns;
tb_i_read_reg_1 <= "00000";
tb_i_read_reg_2 <= "00001";
wait for 50 ns;
end loop;

tb_i_write_en <= '1';
tb_i_write_data <= "00000000000000000000000000000001";
tb_i_write_reg <= "00100";
wait for 100 ns;

tb_i_write_en <= '0';
tb_i_read_reg_1 <= "00100";
wait;
end process;
end behavior;
