library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instr_decoder_tb is
end instr_decoder_tb;

architecture behavior of instr_decoder_tb is

--Component declaration
component instr_decoder
  port (
    i_instr : in std_logic_vector (31 downto 0);
    o_branch : out std_logic;
    o_mem_read : out std_logic;
    o_mem_to_reg : out std_logic;
    o_alu_op : out std_logic_vector (1 downto 0);
    o_mem_write : out std_logic;
    o_alu_src : out std_logic;
    o_reg_write : out std_logic
  );
end component;

--Inputs
signal i_instr_tb : std_logic_vector (31 downto 0) := (others => '0');

--Outputs
signal o_branch_tb : std_logic;
signal o_mem_read_tb : std_logic;
signal o_mem_to_reg_tb : std_logic;
signal o_alu_op_tb : std_logic_vector (1 downto 0);
signal o_mem_write_tb : std_logic;
signal o_alu_src_tb : std_logic;
signal o_reg_write_tb : std_logic;

begin

uut: instr_decoder port map (
    i_instr => i_instr_tb,
    o_branch => o_branch_tb,
    o_mem_read => o_mem_read_tb,
    o_mem_to_reg => o_mem_to_reg_tb,
    o_alu_op => o_alu_op_tb,
    o_mem_write => o_mem_write_tb,
    o_alu_src => o_alu_src_tb,
    o_reg_write => o_reg_write_tb);

stim_process: process
begin

i_instr_tb<="00000000000000000000000000110011";
wait for 50 ns;
i_instr_tb<="00000000000000000000000000000011";
wait for 50 ns;
i_instr_tb<="00000000000000000000000000010011";
wait for 50 ns;
i_instr_tb<="00000000000000000000000000100011";
wait for 50 ns;
i_instr_tb<="00000000000000000000000001100011";
wait for 50 ns;
i_instr_tb<="00000000000000000000000001101111";
wait for 50 ns;
i_instr_tb<="00000000000000000000000001100111";
wait for 50 ns;
wait;

end process;
end behavior;
