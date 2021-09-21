library ieee;
use ieee.std_logic_1164.all;

entity alu is
    generic( 
        N: natural := 8 
    );
    port(
        A, B: in std_logic_vector(N-1 downto 0);
        C: in std_logic_vector(2 downto 0);
        S: out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture structural of alu is

    signal s0, s1 : std_logic_vector(0 to N - 1);

begin

    mux :  entity work.multiplex2x1(behavioral)
        generic map(N => N)
        port map(input0 => s0, input1 => s1, sel => C(0), output => S);

    andor : entity work.andor(behavioral)
        generic map(N => N)
        port map(A => A, B => B, operation => C(1), S => s0);

    addsub : entity work.addsub(behavioral)
        generic map(N => N)
        port map(A => A, B => B, operation => C(2), S => s1);

end architecture;
