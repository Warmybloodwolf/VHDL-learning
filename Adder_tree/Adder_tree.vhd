library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity adder_tree is
    Port (
        AB  : in  STD_LOGIC_VECTOR (255 downto 0);
        R   : out STD_LOGIC_VECTOR (8 downto 0)
    );
end adder_tree;

architecture Behavioral of adder_tree is
    signal sum : unsigned(8 downto 0);
begin
    process(AB)
        variable temp_sum : unsigned(8 downto 0) := (others => '0');
    begin
        -- Initialize temp_sum to 0
        temp_sum := (others => '0');

        -- Sum up all the intermediate values
        for i in 0 to 127 loop
            temp_sum := temp_sum + unsigned(AB(i*2+1 downto i*2));
        end loop;

        sum <= temp_sum;
    end process;
    
    R <= std_logic_vector(sum);
end Behavioral;
