library ieee;
use ieee.std_logic_1164.all;

entity fulladder4 is
    port(
        A, B: in std_logic_vector(3 downto 0);
        CIN: in std_logic;
        S: out std_logic_vector(3 downto 0);
        COUT: out std_logic
    );
end entity;

architecture structural of fulladder4 is

    signal carry : std_logic_vector(2 downto 0) := (others => '0');

begin

    s1b0:   entity work.fulladder1(behavioral)
            port map (A => A(0), B => B(0), CIN => CIN     , S => S(0), COUT => carry(0));

    s1b1:   entity work.fulladder1(behavioral)
            port map (A => A(1), B => B(1), CIN => carry(0), S => S(1), COUT => carry(1));

    s1b2:   entity work.fulladder1(behavioral)
            port map (A => A(2), B => B(2), CIN => carry(1), S => S(2), COUT => carry(2));

    s1b3:   entity work.fulladder1(behavioral)
            port map (A => A(3), B => B(3), CIN => carry(2), S => S(3), COUT => COUT);

end architecture;
