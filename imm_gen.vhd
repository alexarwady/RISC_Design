library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity imm_gen is
  port (
    i_signal: in std_logic_vector (1 downto 0);
    i_imm : in std_logic_vector (31 downto 0);
    o_imm : out std_logic_vector (31 downto 0)
  );
end imm_gen;

architecture rtl of imm_gen is
signal imm_input : std_logic_vector (31 downto 0);
signal imm_input_1 : std_logic_vector (31 downto 0) := (others => '0');

begin
process (i_signal, i_imm, imm_input, imm_input_1)
begin
case i_signal is
--------------------------------------------------------------------------------------------
when "00" => --I type
if (i_imm(31) = '0') then
imm_input <= "00000000000000000000" & i_imm(31 downto 20);
else imm_input <= "11111111111111111111" & i_imm(31 downto 20);
end if;

if (i_imm(6 downto 0) = "0010011" and i_imm(14 downto 12) = "001") then -- if slli
imm_input_1 <= "00000000000000000000" & i_imm(31 downto 20);
imm_input <= "000000000000000000000000000" & imm_input_1(4 downto 0);
end if;

if (i_imm(6 downto 0) = "0010011" and i_imm(14 downto 12) = "101") then -- if srli
imm_input_1 <= "00000000000000000000" & i_imm(31 downto 20);
imm_input <= "000000000000000000000000000" & imm_input_1(4 downto 0);
end if;

o_imm <= imm_input;
--------------------------------------------------------------------------------------------
when "01" => --S type
if (i_imm(31) = '0') then
imm_input <= "00000000000000000000" & i_imm(31 downto 25) & i_imm(11 downto 7);
else imm_input <= "11111111111111111111" & i_imm(31 downto 25) & i_imm(11 downto 7);
end if;

o_imm <= imm_input;
--------------------------------------------------------------------------------------------
when "10" => --SB type
if (i_imm(31) = '0') then
imm_input <= "00000000000000000000" & i_imm(31) & i_imm(7) & i_imm(30 downto 25) & i_imm(11 downto 8);
else imm_input <= "11111111111111111111" & i_imm(31) & i_imm(7) & i_imm(30 downto 25) & i_imm(11 downto 8);
end if;

o_imm <= imm_input;

--imm_input <= std_logic_vector(shift_left(signed(imm_input_1), 1));

--if (i_imm(31) = '0') then
--o_imm <= "00000000000000000000" & imm_input(11 downto 0);
--else o_imm <= "11111111111111111111" & imm_input(11 downto 0);
--end if;
--------------------------------------------------------------------------------------------
when "11" => --UJ type
if (i_imm(31) = '0') then
imm_input_1 <= "000000000000" & i_imm(31) & i_imm(19 downto 12) & i_imm(20) & i_imm(30 downto 21);
else imm_input_1 <= "111111111111" & i_imm(31) & i_imm(19 downto 12) & i_imm(20) & i_imm(30 downto 21);
end if;

imm_input <= std_logic_vector(shift_left(signed(imm_input_1), 1));

if (i_imm(31) = '0') then
o_imm <= "000000000000" & imm_input(19 downto 0);
else o_imm <= "111111111111" & imm_input(19 downto 0);
end if;
--------------------------------------------------------------------------------------------
when others =>
o_imm <= (others => '0');

end case;
end process;
end rtl;

