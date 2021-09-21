library ieee;
use ieee.std_logic_1164.all;

entity serialtoparallel is
    generic (
        N: natural := 8
    );
    port (
        serial_in: in std_logic;
        clk: in std_logic;
        data_out: out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture structural of serialtoparallel is
signal bufer : std_logic_vector(N-1 downto 0);
begin
    wait until clk ='1';
    bit1: entity work.reg_n
        generic map(N => N)
        port map(bufer,clk);
    shift : 
    process
    begin
        for i in 0 to n-2 loop
             bufer(i) <= bufer(i+1);
        end loop;
        bufer(n-1) <= serial_in;
    end process;
    data_out <= bufer;
end architecture;
