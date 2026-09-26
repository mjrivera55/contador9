library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.usar.all;
use IEEE.NUMERIC_STD.ALL;

entity contador is
	Port (
        clk       : in  std_logic; 
        start     : in  std_logic; 
        stop      : in  std_logic; 
        reset     : in  std_logic; 
        min   : out std_logic_vector(6 downto 0); -- Minutos
        sec_t : out std_logic_vector(6 downto 0); -- Decenas Segundos
        sec_u : out std_logic_vector(6 downto 0)  -- Unidades Segundos
    );
end contador;

architecture act of contador is

-- Señales internas
    signal wire_tic     : std_logic;
    signal running      : std_logic := '0';
    signal limite_total  : std_logic;

    signal limt_sec_u   : std_logic;
    signal limt_sec_t   : std_logic;
    signal limt_min_u   : std_logic;

    signal en_sec_u     : std_logic;
    signal en_sec_t     : std_logic;
    signal en_min_u     : std_logic;

    signal bcd_sec_u    : std_logic_vector(3 downto 0);
    signal bcd_sec_t    : std_logic_vector(3 downto 0);
    signal bcd_min_u    : std_logic_vector(3 downto 0);

begin

    -- Instancia Divisor
    U_DIV_1S: divisor_1s
        port map (
            clk   => clk,
            reset => reset,
            tic   => wire_tic
        );

  -- control marcha/parada 
 process (clk,reset)
	begin
		if reset= '1' then
			running <='0';
		elsif rising_edge(clk) then
		 if start='1' then
		 running <='1';
		 elsif stop ='1' or limite_total= '1' then
		 running <='0';
		 end if;
		end if;
	end process;

limite_total <= '1' when (bcd_min_u = "0101" and bcd_sec_t = "1001" and bcd_sec_u = "0100") else '0';

-- Enable Cascade
    en_sec_u <= wire_tic and running and (not limite_total);
    en_sec_t <= en_sec_u and limt_sec_u;
    en_min_u <= en_sec_t and limt_sec_t;
	 
-- Instancias de Contadores
    U_SEC_UNITS: conta_mod_n
        generic map ( BITS => 4 )
        port map (
            clk    => clk,
            rst    => reset,
            enable => en_sec_u,
            mod_n  => to_unsigned(10, 4),
            q      => bcd_sec_u,
            tc     => limt_sec_u
        );

	U_SEC_TENS: conta_mod_n
        generic map ( BITS => 4 )
        port map (
            clk    => clk,
            rst    => reset,
            enable => en_sec_t,
            mod_n  => to_unsigned(6, 4),
            q      => bcd_sec_t,
            tc     => limt_sec_t
        );

	U_MIN_UNITS: conta_mod_n
        generic map ( BITS => 4 )
        port map (
            clk    => clk,
            rst    => reset,
            enable => en_min_u,
            mod_n  => to_unsigned(10, 4),
            q      => bcd_min_u,
            tc     => limt_min_u
        );
		  
-- Instancias conectadas a tu BCD_7SEG
    DEC_SEC_U: BCD_7SEG port map ( A => bcd_sec_u, B => sec_u );
    DEC_SEC_T: BCD_7SEG port map ( A => bcd_sec_t, B => sec_t );
    DEC_MIN_U: BCD_7SEG port map ( A => bcd_min_u, B => min );
	 
end architecture;