library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_memory is
  port (
    i_clk : in std_logic;
    i_write_en : in std_logic;
    i_read_en : in std_logic;
    i_addr : in std_logic_vector (31 downto 0);
    i_write_data : in std_logic_vector (31 downto 0);
    o_read_data : out std_logic_vector (31 downto 0)
  );
end data_memory;

architecture behavioral of data_memory is

type data_mem1 is array (0 to 1023) of std_logic_vector (31 downto 0);

signal DM : data_mem1 := ((others=> (others=>'0')));

begin
process (i_clk, i_write_en, i_read_en)
  begin
  if (i_clk'event and i_clk = '1') then
	if (i_write_en = '1') then
	DM (( to_integer (unsigned (i_addr))) / 4) <= i_write_data;
	end if;

  elsif (i_clk = '0') then
	if (i_read_en = '1') then
	o_read_data <= DM( (to_integer (unsigned (i_addr))) / 4); 
        else o_read_data <= (others => '0');
	end if;

  else o_read_data <= (others => '0');

  end if; 
end process; 

end behavioral;