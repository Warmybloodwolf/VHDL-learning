library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_adder_tree is
end tb_adder_tree;

architecture Behavioral of tb_adder_tree is
    component adder_tree
        Port (
            clk : in  STD_LOGIC;
            AB  : in  STD_LOGIC_VECTOR (255 downto 0);
            R   : out STD_LOGIC_VECTOR (8 downto 0)
        );
    end component;

    signal clk : STD_LOGIC := '0';
    signal AB  : STD_LOGIC_VECTOR (255 downto 0) := (others => '0');
    signal R   : STD_LOGIC_VECTOR (8 downto 0);

    -- Clock generation
    constant clk_period : time := 10 ns;
begin
    -- Instantiate the Unit Under Test (UUT)
    uut: adder_tree Port map (
        clk => clk,
        AB  => AB,
        R   => R
    );

    -- Clock process definitions
    clk_process :process
    begin
        while True loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
    end process;

    -- Stimulus process
    stimulus: process
    begin
        -- Test case 1
        AB <= X"0000000000000000000000000000000000000000000000000000000000000000";
        wait for clk_period;
        
        -- Test case 2
        AB <= X"0101010101010101010101010101010101010101010101010101010101010101";
        wait for clk_period;

        -- Test case 3
        AB <= X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";
        wait for clk_period;

        -- Test case 4
        AB <= X"123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0";
        wait for clk_period;

        wait;
    end process;
end Behavioral;

