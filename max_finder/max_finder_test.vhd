library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_max_finder is
end tb_max_finder;

architecture Behavioral of tb_max_finder is
    component max_finder
        Port (
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            bit_in : in STD_LOGIC_VECTOR (7 downto 0);
            max_val : out STD_LOGIC_VECTOR (15 downto 0);
            max_index : out STD_LOGIC_VECTOR (2 downto 0)
        );
    end component;

    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '0';
    signal bit_in : STD_LOGIC_VECTOR (7 downto 0);
    signal max_val : STD_LOGIC_VECTOR (15 downto 0);
    signal max_index : STD_LOGIC_VECTOR (2 downto 0);

    -- Test vectors
    type mem_array is array (0 to 7) of STD_LOGIC_VECTOR (15 downto 0);
    constant test_values : mem_array := (
        "0001000100010001", -- 4369
        "0000000000000001", -- 1
        "0000000100000001", -- 257
        "0000000000010001", -- 17
        "0001000100000001", -- 4353
        "0000000001000001", -- 65
        "0000100000010001", -- 2065
        "0000000000100001"  -- 33
    );

    signal bit_count : integer := 15;

begin
    UUT: max_finder
        Port map (
            clk => clk,
            rst => rst,
            bit_in => bit_in,
            max_val => max_val,
            max_index => max_index
        );

    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end loop;
    end process;

    rat_process: process
    begin
	wait for 20 ns;
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait;
    end process;
	
    simulation: process
    begin
   	wait for 40 ns;
	for i in 0 to 15 loop
            bit_in <= (others => '0');
            for j in 0 to 7 loop
                bit_in(j) <= test_values(j)(bit_count);
            end loop;
            bit_count <= bit_count - 1;
            wait for 20 ns;
        end loop;
        wait;
    end process;
end Behavioral;

