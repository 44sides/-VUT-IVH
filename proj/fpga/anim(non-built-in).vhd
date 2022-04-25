library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.matrix_pack.all;

entity anim is
    Port ( permission : inout STD_LOGIC;
           data_out : out  std_logic_vector(0 to 127);
			  reset : in std_logic;
			  clk : in std_logic);
end anim;

architecture Behavioral of anim is

	constant const_DATA : std_logic_vector(0 to 127) :=
	"1010101010101010" &
	"0101010101010101" &
	"1010101010101010" &
	"0101010101010101" &
	"1010101010101010" &
	"0101010101010101" &
	"1010101010101010" &
	"0101010101010101";
	
	signal cntr : integer := 0;
	signal EN : std_logic;
	
begin

MOVE_COUNTER : entity work.counter
	GENERIC MAP (CLK_FREQ => 25000000,
					 OUT_FREQ => 5)
	PORT MAP (CLK => clk,
				 RESET => reset,
				 EN => EN);

ANIM_PROC : process(CLK)
begin
if permission = '1' then
	if rising_edge(CLK) then 
			cntr <= cntr + 1;
			if cntr = 0 then
				DATA_OUT <= const_DATA;
			elsif cntr = 1 then
				for i in 0 to 3 loop
					for j in 0 to 15 loop
						DATA_OUT(GETID(i*2,j)) <= '0';
					end loop;
				end loop;
			elsif cntr = 2 then
				for i in 0 to 3 loop
					for j in 0 to 7 loop
						DATA_OUT(GETID(i*2,j*2)) <= '1';
						DATA_OUT(GETID((i*2)+1,j)) <= '0';
					end loop;
				end loop;
			elsif cntr = 3 then
				DATA_OUT <= const_DATA;
			end if;
	end if;
end if;
end process;
end Behavioral;

