library ieee;
use ieee.std_logic_1164.all;

entity paralleltoserial is
    generic( 
        N: natural := 8 
    );
    port(
        data_in: in std_logic_vector(N-1 downto 0);
        serialize_load: in std_logic; -- 1 = serialize, 0 = load
        clk: in std_logic;
        serial_out: out std_logic
    );
end entity;

architecture structural of paralleltoserial is

begin
    so: entity work.reg_n
        port map(data_in,clk);
    process
    variable bufer : std_logic_vector(N-1 downto 0) <= data_in;
    begin
        wait until clk ='1';
            if serialize_load = '1' then
                serial_out = bufer(i);
            else
                for i in 0 to n-2 loop
                    buffer(i) <= buffer(i+1);
                end loop;
                buffer(n-1) < = '0';
                serial_out = bufer(i);
            end if;
    end process;
end architecture;
