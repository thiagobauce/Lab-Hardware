library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity alarm is
    generic (
        N: natural
    );
    port (
        sensors: in std_logic_vector(0 to N-1);
        key: in std_logic;
        clock: in std_logic;
        siren: out std_logic
    );
end entity;

architecture behavioral of alarm is
type alarm_state is (off,arming,armed,triggering,triggered);
signal current, nexts : alarm_state := off;
signal timer_enable             : std_logic := '0';
signal timed                     : std_logic := '0';
signal sensed                    : std_logic := '0';
begin
    process
    begin
        wait until clock ='1';
        current <= nexts;
    end process;
        process (sensors)
        begin
            sensed <= '0';
            for i in sensors'range loop
                if sensors(i) /= '0' then
                    sensed <= '1';
                end if;
            end loop;
        end process;

        process
        variable v_count : natural := 0;
        begin
            timed <= '0';
            loop
                loop
                    wait until clock = '1' or timer_enable = '0';
                    exit when timer_enable = '0';
                    v_count := v_count + 1;
                    if v_count > 30 then
                        timed <= '1';
                        timer_enable <= '0';
                    else
                        timed <= '0';
                    end if;
                end loop;
                v_count := 0;
                timed <= '0';
            end loop;
        end process;

        process (current,sensed,key,sensors,timed)
        begin
            case current is
                when off =>
                    if key = '0' then
                        nexts <= off;
                    else
                        nexts <=arming;
                    end if;
                    timer_enable <= '0';
                when arming =>
                    if key = '0' then
                        nexts <= off;
                    elsif timed = '1'then
                        nexts <= armed;
                    end if;
                    timer_enable <= '1';
                when armed =>
                    if key = '0' then
                        nexts <= off;
                    elsif sensed = '0' then
                        nexts <= armed;
                    elsif sensed = '1' then
                        nexts <= triggering;
                    end if;
                    timer_enable <= '0';   
                when triggering =>
                    if key = '0' then
                        nexts <= off;
                    elsif timed = '1' then
                        nexts <= triggered;
                    end if;
                    timer_enable <= '1';  
                when triggered =>
                    if key = '0' then
                        nexts <= off;
                    else
                        nexts <= triggered;
                    end if;
            end case;
        end process;

        process(current)
        begin
            if current = triggered then
                siren <= '1';
            else
                siren <= '0';
            end if;
        end process;
        
end architecture;
