library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.matrix_pkg.ALL; -- ????? package

entity matrix_multiplier is
    Port (
        clk  : in  STD_LOGIC;
        rst  : in  STD_LOGIC;
        A    : in  STD_LOGIC_VECTOR_ARRAY; -- ???????
        W    : in  STD_LOGIC_VECTOR_ARRAY; -- ???????
        Z    : out STD_LOGIC_VECTOR (15 downto 0) -- 16-bit output
    );
end matrix_multiplier;

architecture Behavioral of matrix_multiplier is
    signal product : STD_LOGIC_VECTOR (255 downto 0);
    signal A_counter : integer range 0 to 3 := 3;
    signal W_counter : integer range 0 to 7 := 7;
    
    -- Components declaration
    component adder_tree is
        Port (
            clk : in  STD_LOGIC;
            AB  : in  STD_LOGIC_VECTOR (255 downto 0);
            R   : out STD_LOGIC_VECTOR (8 downto 0)
        );
    end component;

    component shiftAdd is
        Port ( 
            R : in STD_LOGIC_VECTOR (8 downto 0); -- 9-bit input
            SIGN : in STD_LOGIC; -- 1-bit sign flag
            CLK1 : in STD_LOGIC; -- Clock signal for left DFF
            CLK2 : in STD_LOGIC; -- Clock signal for right DFF
            RST1 : in STD_LOGIC; -- Reset signal for the first DFF
            RST2 : in STD_LOGIC; -- Reset signal for the second DFF
            Z : out STD_LOGIC_VECTOR (15 downto 0) -- 16-bit output
        );
    end component;

    signal adder_tree_clk : STD_LOGIC;
    signal adder_tree_input : STD_LOGIC_VECTOR(255 downto 0);
    signal adder_tree_output : STD_LOGIC_VECTOR(8 downto 0);
    signal shiftadd_input : STD_LOGIC_VECTOR(8 downto 0);
    signal shiftadd_clk_left : STD_LOGIC;
    signal shiftadd_clk_right : STD_LOGIC;
    signal shiftadd_rst_left : STD_LOGIC;
    signal shiftadd_rst_right : STD_LOGIC;
    signal shiftadd_output : STD_LOGIC_VECTOR (15 downto 0);
    signal sign : STD_LOGIC;
begin
    Adder_tree_inst: adder_tree
        port map (
            clk => adder_tree_clk,
            AB => adder_tree_input,
            R => adder_tree_output
        );

    adder_tree_clk <= clk;
    adder_tree_input <= product;

    ShiftAdd_inst: shiftAdd 
        port map (
            R => shiftadd_input,
            SIGN => sign,
            CLK1 => shiftadd_clk_left,
            CLK2 => shiftadd_clk_right,
            RST1 => shiftadd_rst_left,
            RST2 => shiftadd_rst_right,
            Z => shiftadd_output
        );

    shiftadd_input <= adder_tree_output;
    shiftadd_clk_left <= clk;
    shiftadd_clk_right <= '1' when A_counter = 2 else '0';
    Z <= shiftadd_output;
    sign <= '1' when W_counter = 6 else '0';

    process(clk, rst)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                shiftadd_rst_left <= '1';
                shiftadd_rst_right <= '1';
                A_counter <= 3;
                W_counter <= 7;
            else
                shiftadd_rst_left <= '0';
                shiftadd_rst_right <= '0';
                if A_counter = 0 then
                    if W_counter = 0 then
                        W_counter <= 7; -- Reset W to 7
                    else
                        W_counter <= W_counter - 1; -- Decrement W
                    end if;
                    A_counter <= 3; -- Reset A to 3
                else
                    A_counter <= A_counter - 1; -- Decrement A
                end if;
            end if;
        end if;
        if falling_edge(clk) then
            if shiftadd_clk_right = '1' then
                shiftadd_rst_left <= '1';
            end if;
        end if;
    end process;

    -- Generate product signals
    process(A_counter, W_counter)
    begin
        for i in 0 to 127 loop
            if W(i)(W_counter) = '1' then
                product(i*2) <= A(i)(A_counter*2);
                product(i*2+1) <= A(i)(A_counter*2+1);
            else
                product(i*2) <= '0';
                product(i*2+1) <= '0';
            end if;
        end loop;
    end process;

    
    
end Behavioral;

