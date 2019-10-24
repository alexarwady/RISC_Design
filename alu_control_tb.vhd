library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_control_tb is
end alu_control_tb;

architecture behavior of alu_control_tb is

--Component declaration
component alu_control
  port (
    i_alu_op : in std_logic_vector (1 downto 0);
    i_func3: in std_logic_vector (2 downto 0);
    i_instr_30 : in std_logic;
    o_operation : out std_logic_vector (3 downto 0)
  );
end component;

--Inputs
signal i_alu_op_tb : std_logic_vector (1 downto 0) := (others => '0');
signal i_func3_tb : std_logic_vector (2 downto 0) := (others => '0');
signal i_instr_30_tb : std_logic := '0';

--Outputs
signal o_operation_tb : std_logic_vector (3 downto 0);

begin

uut: alu_control port map (
i_alu_op => i_alu_op_tb,
i_func3 => i_func3_tb,
i_instr_30 => i_instr_30_tb,
o_operation => o_operation_tb);

stim_process: process
begin

i_alu_op_tb <= "00";
i_instr_30_tb <= '0';

i_func3_tb <= "000";
wait for 50 ns;

for i in 0 to 7 loop
i_func3_tb <= std_logic_vector( unsigned(i_func3_tb) + 1 );
wait for 50 ns;
end loop;

i_alu_op_tb <= "01";
i_func3_tb <= "000";
wait for 50 ns;
i_func3_tb <= "100";
wait for 50 ns;

i_alu_op_tb <= "10";
i_func3_tb <= "000";
wait for 50 ns;

for i in 0 to 7 loop
i_func3_tb <= std_logic_vector( unsigned(i_func3_tb) + 1 );
wait for 50 ns;
end loop;

i_instr_30_tb <= '1';
i_func3_tb <= "000";
wait for 50 ns;

i_alu_op_tb <= "11";
i_func3_tb <= "010";
i_instr_30_tb <= '0';
wait for 50 ns;

wait;

end process;
end behavior;
