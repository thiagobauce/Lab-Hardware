library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity estacionamento is
    generic ( max: natural );
    
    port (
        a, b: in std_logic;
        clock, reset: in std_logic;
        
        numring: out natural;
        ring: out std_logic
    );
end entity;

architecture behavioral of estacionamento is
type varState is (x1, core_2, core_3, core_4, core_5,
                    core_6, core_7, core_8, core_9);
signal now, nextState: varState := x1;
begin
    process(clock, reset)
        variable car_temp: natural;
        variable locate_lin: std_logic;
    begin
        if reset = '1' then
            numring <= 0;
            ring <= '0';
            now <= x1;
        elsif (rising_edge(clock)) then
            if (now = core_5 and nextState = x1) then
                car_temp := car_temp + 1;
                if (car_temp >= max) then
                    locate_lin := '1';
                elsif (car_temp < max) then
                    locate_lin := '0';
                end if;
                numring <= car_temp;
                ring <= locate_lin;
                now <= nextState;
            elsif (now = core_9 and nextState = x1) then
                car_temp := car_temp - 1;
                if (car_temp >= max) then
                    locate_lin := '1';
                elsif (car_temp < max) then
                    locate_lin := '0';
                end if;
                numring <= car_temp;
                ring <= locate_lin;
                now <= nextState;
            else
                now <= nextState;
            end if;
        end if;
    end process;
    process(now, a, b)
    begin
        case now is
            when x1 =>
                if (a = '0' and b = '0') then
                    nextState <= x1;
                elsif (a = '1' and b = '0') then
                    nextState <= core_2;
                elsif (a = '0' and b = '1') then
                    nextState <= core_6;
                end if;
                
            when core_2 =>
                if (a = '0' and b = '0') then
                    nextState <= x1;
                elsif (a = '1' and b = '1') then
                    nextState <= core_3;
                end if;
            when core_3 =>
                if (a = '0' and b = '0') then
                    nextState <= x1;
                elsif (b = '1' and a = '0') then
                    nextState <= core_4;
                end if;
            when core_4 =>
                if (a = '0' and b = '0') then
                    nextState <= core_5;
                end if;
            when core_5 =>
                nextState <= x1;
            when core_6 =>
                if(b = '0' and a = '0') then
                    nextState <= x1;
                elsif (b = '1' and a = '1') then
                    nextState <= core_7;
                end if;
            when core_7 =>
                if(b = '0' and a = '0') then
                    nextState <= x1;
                elsif (a = '1' and b = '0') then
                    nextState <= core_8;
                end if;
            when core_8 =>
                if (a = '0' and b = '0') then
                    nextState <= core_9;
                end if;
            when core_9 =>
                nextState <= x1;    
        end case;
    end process;
end architecture;