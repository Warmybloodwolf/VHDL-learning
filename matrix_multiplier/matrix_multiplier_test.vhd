library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.matrix_pkg.ALL;

entity matrix_multiplier_tb is
end matrix_multiplier_tb;

architecture Behavioral of matrix_multiplier_tb is
    -- Constants for test
    constant CLK_PERIOD : time := 10 ns;

    -- Testbench signals
    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '1';
    signal A : STD_LOGIC_VECTOR_ARRAY := (others => (others => '0'));
    signal W : STD_LOGIC_VECTOR_ARRAY := (others => (others => '0'));
    signal Z : STD_LOGIC_VECTOR(15 downto 0);

    -- UUT (Unit Under Test)
    component matrix_multiplier is
        Port (
            clk  : in  STD_LOGIC;
            rst  : in  STD_LOGIC;
            A    : in  STD_LOGIC_VECTOR_ARRAY;
            W    : in  STD_LOGIC_VECTOR_ARRAY;
            Z    : out STD_LOGIC_VECTOR (15 downto 0)
        );
    end component;

begin
    -- Clock generation
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Instantiate the Unit Under Test (UUT)
    UUT: matrix_multiplier
        Port map (
            clk => clk,
            rst => rst,
            A => A,
            W => W,
            Z => Z
        );

    -- Stimulus process
    stimulus : process
    begin
        -- Reset
        rst <= '1';
        wait for 20 ns;
        rst <= '0';

         -- Test Case 1: Specific values for A and W
         A(0) <= "00000010";
         A(1) <= "00000011";
         -- All other values of A remain 0
         for i in 2 to 127 loop
             A(i) <= "00000000";
         end loop;
         
         W(0) <= "00001000";
         W(1) <= "11111010";
         -- All other values of W remain 0
         for i in 2 to 127 loop
             W(i) <= "00000000";
         end loop;

        wait for 100 ns;

        -- Check output
        -- assert Z = expected_value
        -- report "Test Case 1 failed"
        -- severity error;

        -- Add more test cases as needed

        wait;
    end process;

end Behavioral;

