library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity conta_mod_n is
 generic (
        BITS : integer := 4 ---sirve para parametrizar un componente
    );
port (
        clk    : in  std_logic;
        rst    : in  std_logic; --Reset
        enable     : in  std_logic; ---Habilitador de conteo
		  mod_n  : in  unsigned(BITS - 1 downto 0); -- Define el límite del módulo N
        q : out std_logic_vector(BITS - 1 downto 0); --Valor actual del contador expresado en binario.
        tc     : out std_logic --Fin de Conteo cuando N-1
    );
end entity conta_mod_n;

architecture confi of conta_mod_n is
	signal cuenta : unsigned(BITS - 1 downto 0) := (others => '0'); ---almacena internamente la cuenta
	
	begin 
	 process(clk)
    begin
	  if rising_edge (clk) then
	    if rst= '1' then
			cuenta <= (others => '0');
			else
			----Protección de módulo inválido
				if mod_n <= 1 then
                    cuenta <= (others => '0');
					-----Habilitador
                elsif enable = '1' then
                        if cuenta = (mod_n - 1) then
                            cuenta <= (others => '0');
                        else
                            cuenta <= cuenta + 1;
                        end if;
							end if;
						end if;
					end if;
			end process;
			
    -- Salida tc: '1' 
    tc <= '1' when (cuenta >= mod_n - 1 and enable = '1') else '0';


q <= std_logic_vector(cuenta);

end architecture confi;
		
	
           
	   