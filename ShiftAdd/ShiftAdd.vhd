library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ShiftAdd is
    Port ( 
        R : in STD_LOGIC_VECTOR (8 downto 0); -- 9-bit input
        SIGN : in STD_LOGIC; -- 1-bit sign flag
        CLK1 : in STD_LOGIC; -- Clock signal for left DFF
        CLK2 : in STD_LOGIC; -- Clock signal for right DFF
        RST1 : in STD_LOGIC; -- Reset signal for the first DFF
        RST2 : in STD_LOGIC; -- Reset signal for the second DFF
        Z : out STD_LOGIC_VECTOR (15 downto 0) -- 16-bit output
    );
end ShiftAdd;

architecture Behavioral of ShiftAdd is
    signal D_left, D_right : STD_LOGIC_VECTOR (15 downto 0); -- Accumulator registers
begin
    process(CLK1, RST1, CLK2, RST2)
        variable R_ext, shifted_D_left, xor_D_left, D_complement, shifted_D_right: unsigned (15 downto 0); 
        variable SIGN_ext : unsigned(15 downto 0);
        variable SIGN_vector : std_logic_vector(15 downto 0);
    begin
        -- Extend R to 16 bits and convert to unsigned
        R_ext := unsigned("0000000" & R);

        -- Shift D_left left by 2 bits and convert to unsigned
        shifted_D_left := unsigned(D_left(13 downto 0) & "00");

        -- XOR D_left with SIGN and convert to unsigned
        for i in 0 to 15 loop
            xor_D_left(i) := D_left(i) xor SIGN;
        end loop;

        -- Extend SIGN to 16 bits and convert to unsigned
        SIGN_vector := (others => '0');
        SIGN_vector(0) := SIGN;
        SIGN_ext := unsigned(SIGN_vector);

        -- Add SIGN_ext to xor_D_left
        D_complement := xor_D_left + SIGN_ext;

        -- Reset or update D_left
        if RST1 = '1' then
            D_left <= (others => '0');
        elsif rising_edge(CLK1) then
            D_left <= std_logic_vector(shifted_D_left + R_ext);
        end if;

        -- Shift D_right right by 1 bits and convert to unsigned 
        shifted_D_right := unsigned(D_right(14 downto 0) & "0");

        -- Reset or update D_right
        if RST2 = '1' then
            D_right <= (others => '0');
        elsif rising_edge(CLK2) then
            D_right <= std_logic_vector(shifted_D_right + D_complement);
        end if;
    end process;

    -- Assign the output Z
    Z <= D_right;
end Behavioral;
