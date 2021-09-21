library ieee;
use ieee.std_logic_1164.all;

entity multiplex2x1 is
    generic (
        N: natural := 4
    );
    port (
        input0, input1: in std_logic_vector(N-1 downto 0);
        sel: in std_logic;
        output: out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture behavioral of multiplex2x1 is
begin

    process (input0, input1, sel)
    begin
        if sel = '0' then
            output <= input0;
        else
            output <= input1;
        end if;
    end process;

end architecture;