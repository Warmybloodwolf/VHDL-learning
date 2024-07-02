library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_ShiftAdd is
end tb_ShiftAdd;

architecture Behavioral of tb_ShiftAdd is
    -- Component Declaration
    component ShiftAdd
        Port ( 
            R : in STD_LOGIC_VECTOR (8 downto 0);
            SIGN : in STD_LOGIC;
            CLK1 : in STD_LOGIC;
            CLK2 : in STD_LOGIC;
            RST1 : in STD_LOGIC;
            RST2 : in STD_LOGIC;
            Z : out STD_LOGIC_VECTOR (15 downto 0)
        );
    end component;

    -- Testbench signals
    signal R : STD_LOGIC_VECTOR (8 downto 0) := (others => '0');
    signal SIGN : STD_LOGIC := '0';
    signal CLK1 : STD_LOGIC := '0';
    signal CLK2 : STD_LOGIC := '0';
    signal RST1 : STD_LOGIC := '0';
    signal RST2 : STD_LOGIC := '0';
    signal Z : STD_LOGIC_VECTOR (15 downto 0);

    -- Clock period definition
    constant CLK_PERIOD : time := 10 ns;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: ShiftAdd Port map (
        R => R,
        SIGN => SIGN,
        CLK1 => CLK1,
        CLK2 => CLK2,
        RST1 => RST1,
        RST2 => RST2,
        Z => Z
    );

    -- Clock process
    clk1_process :process
    begin
        CLK1 <= '0';
        wait for CLK_PERIOD/2;
        CLK1 <= '1';
        wait for CLK_PERIOD/2;
    end process;

    clk2_process :process
    begin
        CLK2 <= '0';
        wait for CLK_PERIOD;
        CLK2 <= '1';
        wait for CLK_PERIOD;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Reset all signals
        RST1 <= '1';
        RST2 <= '1';
        wait for 20 ns;
        
        RST1 <= '0';
        RST2 <= '0';
        
        -- Apply test vectors
        R <= "000000001"; -- 1
        SIGN <= '0';
        wait for 20 ns;
        
        R <= "000000010"; -- 2
        SIGN <= '1';
        wait for 20 ns;
        
        R <= "000000011"; -- 3
        SIGN <= '0';
        wait for 20 ns;
        
        -- Add more test vectors as needed
        R <= "000000100"; -- 4
        SIGN <= '1';
        wait for 20 ns;
        
        -- Reset the system
        RST1 <= '1';
        wait for 10 ns;
        RST1 <= '0';
        wait for 10 ns;
        
        RST2 <= '1';
        wait for 10 ns;
        RST2 <= '0';
        wait for 10 ns;
        
        -- More test cases can be added here
        wait;
    end process;

end Behavioral;

