library IEEE;
use IEEE.STD_LOGIC_1164.all;

package matrix_pack is

function GETID(X,Y : integer) return integer;
type DIRECTION_T is (dir_left, dir_right);

end matrix_pack;

package body matrix_pack is

	function GETID(X,Y : integer) return integer is
	variable r : integer := X;
	variable c : integer := Y;
	variable ROWS : integer := 8;
	variable COLS : integer := 16;
	begin
		r := X mod ROWS;
		c := Y mod COLS;

		return r*COLS+c;
	end GETID;
 
end matrix_pack;
