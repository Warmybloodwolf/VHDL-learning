library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.config_pkg.all;  

entity priority_encoder is
    port (
        DIN  : in  std_logic_vector(WIDTH-1 downto 0);
        DZ   : out std_logic;
        DOUT : out std_logic_vector(7 downto 0)
    );
end priority_encoder;

architecture Behavioral of priority_encoder is
begin
    process(DIN)
    variable index       : integer := 0;
    variable found       : boolean := false;
    begin
        DZ <= '1';
        DOUT <= (others => '0');
        for i in DIN'range loop
            if DIN(i) = '1' then
                index := i;
                found := true;
                exit;  -- ?????1?????
            end if;
        end loop;
        if found then
            DZ <= '0';
            DOUT <= std_logic_vector(to_unsigned(index, 8));
        end if;
    end process;
end Behavioral;

