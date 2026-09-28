library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity divisor_1s is
    Port (
        clk     : in  std_logic;
		  reset     : in  STD_LOGIC;
        tic : out std_logic
    );
end divisor_1s;

----49999999

architecture tiempo of divisor_1s is 
    constant TOPE : integer := 49999999;
    signal tiempo : integer range 0 to TOPE := 0;
 
 begin
	
	process(clk,reset)
	begin
	
	if reset='1' then 
		tiempo <= 0;
		tic <='0';
	
	elsif rising_edge(clk) then
	
		if tiempo= TOPE then
		
			tiempo<=0;
			tic <='1';
	 
		else 
		
			tiempo <= tiempo+1;
			tic <='0';
			
		end if;
		
	  end if; 

  end process;

end tiempo;
	 