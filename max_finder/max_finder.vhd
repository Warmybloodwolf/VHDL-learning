library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity max_finder is
    Port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        bit_in : in STD_LOGIC_VECTOR (7 downto 0);
        max_val : out STD_LOGIC_VECTOR (15 downto 0);
        max_index : out STD_LOGIC_VECTOR (2 downto 0);
	busy : out STD_LOGIC
    );
end max_finder;

architecture Behavioral of max_finder is
    type value_array is array (0 to 7) of STD_LOGIC_VECTOR (15 downto 0);
    signal values : value_array;
    signal valid : STD_LOGIC_VECTOR (7 downto 0);
    signal bit_counter : INTEGER := 0;
begin
    busy <= '1' when bit_counter /= 0 else '0';
    process(clk, rst)
	variable and_result : STD_LOGIC_VECTOR (7 downto 0);
    begin
        if rst = '1' then
            values <= (others => (others => '0'));
            valid <= (others => '1');
            bit_counter <= 15;
            max_val <= (others => '0');
            max_index <= "000";
        elsif rising_edge(clk) then
            -- Shift in the bits
            for i in 0 to 7 loop
                values(i)(bit_counter) <= bit_in(i);
            end loop;

            -- Update the valid bits
            if bit_counter >= 0 then
		and_result := valid and bit_in;
                if and_result /= "00000000" then
                    for i in 0 to 7 loop
                        if bit_in(i) = '0' then
                            valid(i) <= '0';
                        end if;
                    end loop;
                end if;
            end if;

            -- Find the maximum value and index when all bits are shifted
            if bit_counter = 0 then
                for i in 0 to 7 loop
                    if valid(i) = '1' then
                        max_val <= values(i);
                        max_index <= conv_std_logic_vector(i, 3);
			max_val(0) <= bit_in(i);
                        exit;
                    end if;
                end loop;
            end if;

            -- Decrement the bit counter
            if bit_counter > 0 then
                bit_counter <= bit_counter - 1;
            end if;
        end if;
    end process;
end Behavioral;

