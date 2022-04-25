library IEEE;
use IEEE.STD_LOGIC_1164.all;

package move_pack is

function MOVE_DATA(DATA : std_logic_vector(0 to 127); DIRECTION : std_logic) return std_logic_vector;

end move_pack;

package body move_pack is

	function MOVE_DATA(DATA : std_logic_vector(0 to 127); DIRECTION : std_logic) return std_logic_vector is
	variable new_data : std_logic_vector(0 to 127) := DATA;
	variable factor : integer := 0;

	begin

	if DIRECTION = '1' then
		
		for i in 0 to 14 loop
			for factor in 0 to 7 loop
				new_data((16*factor+1)+i) := data((16*factor)+i);
			end loop;
		end loop;
		
		for factor in 0 to 7 loop
			new_data(16*factor) := data(16*factor+15);
		end loop;
		
	else 

		for i in 0 to 14 loop
			for factor in 0 to 7 loop
				new_data((16*factor)+i) := data((16*factor+1)+i);
			end loop;
		end loop;

		for factor in 0 to 7 loop
			new_data(16*factor+15) := data(16*factor);
		end loop;
	
	end if;
			
	return std_logic_vector(new_data);
	end MOVE_DATA;
 
end move_pack;