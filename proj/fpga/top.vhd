-- Blikani ledkami
-- uvodni priklad pro IVH - Vojtech Mrazek
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.fpga_cfg.all;
use work.move_pack.all;
use work.matrix_pack.all;

architecture main of tlv_gp_ifc is
   signal A : std_logic_vector(3 downto 0) := (others => '0');
   signal R : std_logic_vector(7 downto 0); 
	signal DATA : std_logic_vector(0 to 127);
	
	constant SIGN_DATA : std_logic_vector(0 to 127) :=
		"0000000000000000" &
		"0000000000000000" &
		"1000000010111110" &
		"0100000100001000" &
		"0010001000001000" &
		"0001010000001000" &
		"0000100001001001" &
		"0000000000000000";
		
	signal reset_dis : std_logic := '0'; 
		
	signal reset_mv_cntr : std_logic := '0'; 
	signal reset_an_cntr : std_logic := '1'; 
	
	signal EN_mv : std_logic;
	signal EN_an : std_logic;
	
	signal move_cntr : std_logic_vector(7 downto 0) := (others => '0');
	signal anim_cntr : std_logic_vector(7 downto 0) := (others => '0');
	
	constant ANIM_DATA : std_logic_vector(0 to 127) :=
		"1010101010101010" &
		"0101010101010101" &
		"1010101010101010" &
		"0101010101010101" &
		"1010101010101010" &
		"0101010101010101" &
		"1010101010101010" &
		"0101010101010101";

begin

	MOVE_COUNTER : entity work.counter
	GENERIC MAP (CLK_FREQ => 25000000,
					 OUT_FREQ => 10)
	PORT MAP (CLK => clk,
				 RESET => reset_mv_cntr,
				 EN => EN_mv);
				 
	ANIM_COUNTER : entity work.counter
	GENERIC MAP (CLK_FREQ => 25000000,
					 OUT_FREQ => 14)
	PORT MAP (CLK => clk,
				 RESET => reset_an_cntr,
				 EN => EN_an);
				 
	MOVE_PROC : process (CLK)
	begin
	if rising_edge(CLK) then 
		reset_dis <= '0';
		
		if EN_mv = '1' then
			reset_dis <= '1';
			move_cntr <= move_cntr + 1;
			if(move_cntr = 0) then
				DATA <= SIGN_DATA;
			end if;
			if(move_cntr > 0 and move_cntr < 49) then
				DATA <= MOVE_DATA(DATA, '1');
			end if;
			if(move_cntr >= 49 and move_cntr < 97) then
				DATA <= MOVE_DATA(DATA, '0');
			end if;
			if(move_cntr = 97) then
				reset_mv_cntr <= '1';
				reset_an_cntr <= '0';
				move_cntr <= (others => '0');
			end if;
			
		elsif EN_an = '1' then
			--anim--
			anim_cntr <= anim_cntr + 1;
			if anim_cntr = 0 then
				DATA <= (others => '0');
			elsif anim_cntr = 14 then
				for i in 0 to 3 loop
					for j in 0 to 7 loop
						DATA(GETID(i*2,j*2)) <= '1';
					end loop;
				end loop;
			elsif anim_cntr = 28 then
				for i in 0 to 3 loop
					for j in 0 to 7 loop
						DATA(GETID(i*2,j*2)) <= '0';
						DATA(GETID((i*2)+1,(j*2)+1)) <= '1';
					end loop;
				end loop;
			elsif anim_cntr = 42 then
				DATA <= ANIM_DATA;
			elsif anim_cntr >= 56 and anim_cntr <= 70 then
				DATA <= MOVE_DATA(DATA, '1');
			elsif anim_cntr = 71 then
				DATA <= (others => '0');
			elsif anim_cntr = 85 then
				reset_mv_cntr <= '0';
				reset_an_cntr <= '1';
				anim_cntr <= (others => '0');
			end if;
			--anim--
			
		end if;
	end if;
	
end process;
				 
	dis : entity work.display port map (
		CLK => CLK,
		SMCLK => SMCLK,
		RESET => reset_dis,
		DATA => DATA,
		A => A,
		R => R
	);

    -- mapovani vystupu
    -- nemenit
    X(6) <= A(3);
    X(8) <= A(1);
    X(10) <= A(0);
    X(7) <= '0'; -- en_n
    X(9) <= A(2);

    X(16) <= R(1);
    X(18) <= R(0);
    X(20) <= R(7);
    X(22) <= R(2);
  
    X(17) <= R(4);
    X(19) <= R(3);
    X(21) <= R(6);
    X(23) <= R(5);
end main;

