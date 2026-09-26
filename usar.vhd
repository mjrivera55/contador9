library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package usar is
 
 component BCD_7SEG is
	port(A: in STD_LOGIC_VECTOR(3 downto 0);
		  B: out STD_LOGIC_VECTOR(6 downto 0));
end component;

  component divisor_1s is
	Port (
        clk     : in  std_logic;
		  reset     : in  STD_LOGIC;
        tic : out std_LOGIC
    );
	end component;
	
 component  conta_mod_n
 generic (
        BITS : integer := 4
    );
	port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        enable     : in  std_logic;
		  mod_n  : in  unsigned(BITS - 1 downto 0);
        q      : out std_logic_vector(6 downto 0);
        tc     : out std_logic
    );
end component;


end package;