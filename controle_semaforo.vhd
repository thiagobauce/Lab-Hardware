library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity controle_semaforo is
    port (
        clock: in std_logic;
        alert: in std_logic;
        ledr: out std_logic_vector(17 downto 0);
        ledg: out std_logic_vector(17 downto 0)
    );
end entity;

architecture behavioral of controle_semaforo is
type state is (RG, RY, GR, YR, YY);
signal atual, prox : state := RG;
signal cont: natural := 0;
signal flag: bit; --zera o contador (cont)

signal tempRG : natural := 2500;
signal tempRY : natural := 1500;
signal tempGR : natural := 3000;
signal tempYR : natural := 1500;

begin
    sincroniza: process(clock)
    begin
        if clock' event and clock = '1' then
            if alert = '1' then
                atual <= YY;
            else
                atual <= prox;
            end if;
        end if;        
    end process sincroniza;

    mud_est: process (atual, cont)
    begin
        case atual is
        when RG =>
            ledr(0) <= '1';
            ledg(0) <= '0';
            ledr(1) <= '0';
            ledg(1) <= '1';
            flag <= '0';
            if(cont = tempRG) then
                flag <= '1';
                prox <= RY;
            else
                prox <= RG;
            end if;
        when RY =>
            ledr(0) <= '1';
            ledg(0) <= '0';
            ledr(1) <= '1';
            ledg(1) <= '1';
            flag <= '0';
            if(cont = tempRY) then
                flag <= '1';
                prox <= GR;
            else
                prox <= RY;
            end if;
        when GR =>
            ledr(0) <= '0';
            ledg(0) <= '1';
            ledr(1) <= '1';
            ledg(1) <= '0';
            flag <= '0';
            if(cont = tempGR) then
                flag <= '1';
                prox <= YR;
            else
                prox <= GR;
            end if;
        when YR =>
            ledr(0) <= '1';
            ledg(0) <= '1';
            ledr(1) <= '1';
            ledg(1) <= '0';
            flag <= '0';
            if(cont = tempYR) then
                flag <= '1';
                prox <= RG;
            else
                prox <= YR;
            end if;
        when YY =>
            ledr(0) <= '1';
            ledg(0) <= '1';
            ledr(1) <= '1';
            ledg(1) <= '1';
            flag <= '1';
            prox <= RG;                 
        end case;
    end process;

    contador: process (clock)
    begin
        if(clock = '1') then
            if(atual = YY) then
                cont <= 0;
            elsif(flag = '1') then
                cont <= 0;
            else
                cont <= cont+1;
            end if;
        end if;     
    end process;

end architecture;