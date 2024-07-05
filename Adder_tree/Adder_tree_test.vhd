library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_adder_tree is
end tb_adder_tree;

architecture Behavioral of tb_adder_tree is
    component adder_tree
        Port (
            AB  : in  STD_LOGIC_VECTOR (255 downto 0);
            R   : out STD_LOGIC_VECTOR (8 downto 0)
        );
    end component;

    signal AB  : STD_LOGIC_VECTOR (255 downto 0) := (others => '0');
    signal R   : STD_LOGIC_VECTOR (8 downto 0);

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: adder_tree Port map (
        AB  => AB,
        R   => R
    );

    -- Stimulus process
    stimulus: process
    begin
        -- Test case 1
        AB <= X"0000000000000000000000000000000000000000000000000000000000000000";
        wait for 10 ns;

        -- Test case 2
        AB <= X"0101010101010101010101010101010101010101010101010101010101010101";
        wait for 10 ns;

        -- Test case 3
        AB <= X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";
        wait for 10 ns;

        -- Test case 4
        AB <= X"123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0";
        wait for 10 ns;
        
        wait;
    end process;
end Behavioral;
