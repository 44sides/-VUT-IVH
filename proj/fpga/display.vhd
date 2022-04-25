-- Blikani ledkami
-- uvodni priklad pro IVH - Vojtech Mrazek
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- DO entity nezasahujte, bude pouzita k simulaci!
entity display is
	port (
		data : in std_logic_vector(0 to 127); -- data k zobrazeni, format je na popsany dole
		reset : in std_logic;
		clk : in std_logic; -- hodiny 25 MHz
		smclk : in std_logic; -- hodiny 7.3728MHz
		A : out std_logic_vector(3 downto 0);
		R : out std_logic_vector(7 downto 0)
	);
end entity display;

architecture behv of display is
   constant TMR : natural := 20; -- 18 je normalni

   signal cnt : std_logic_vector(23 downto 0) := (others => '0');
   signal A_temp : std_logic_vector(3 downto 0) := (others => '0');
   signal R_temp : std_logic_vector(7 downto 0); 
	-- definujte si libovolne signaly
	signal reset_ctr : std_logic := '0';
	signal EN : std_logic;
	signal col_cntr : std_logic_vector(3 downto 0) := (others => '0');
begin

-- Vystupni logika. Vas ukol: vse smazat a naimplementovat zobrazeni matice z vektoru data
-- prvek 0 ukazuje 0. radek a 0. sloupec
-- prvek 1 ukazuje 0. radek a 1. sloupec
-- prvek 127 ukazuje na 7. radek a 15. sloupec

-- cilem je to, aby byl text citelny!
			
COUNTER : entity work.counter
	GENERIC MAP (CLK_FREQ => 25000000,
					 OUT_FREQ => 500*16)
	PORT MAP (CLK => clk,
				 RESET => reset,
				 EN => EN);
	
OUTPUT_PROC : process(CLK, reset) 
begin
	if reset = '1' then
		col_cntr <= "0000";
	elsif rising_edge(CLK) then 
		if EN = '1' then
		
			for num in 0 to 7 loop
				R(num) <= data(16*num + TO_INTEGER(unsigned(col_cntr)));
			end loop;
			
			A <= col_cntr;
	
			col_cntr <= col_cntr + 1;
	
	
		end if;
	end if;
end process;


end behv;