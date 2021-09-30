library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity washcontrol is
    port (
        inicia, cheia, tempo, vazia: in std_logic;
        clock: in std_logic;   
        entrada_agua: out std_logic :='0';
        aciona_motor: out std_logic :='0';
        saida_agua: out std_logic :='0'
    );
end entity;

architecture behavioral of washcontrol is
type wash_state is (off,filling,full,emptying,empty);
signal current, nexts : wash_state := off;
begin -- arch
    process
    begin
        wait until clock ='1';
        current <= nexts;
    end process;
    process (current,tempo,inicia,cheia,vazia)
    begin
        case current is
            when off =>
                if inicia = '0' then
                    nexts <= off;
                else
                    nexts <=filling;
                end if;
            when filling =>
                if cheia = '0' then
                    nexts <= filling;
                else
                    nexts <= full;
                end if;
            when full =>
                if tempo = '0' then
                    nexts <= full;
                else
                    nexts <= emptying;
                end if;
            when emptying =>
                if vazia = '0' then
                    nexts <= emptying;
                else
                    nexts <= empty;
                end if;
            when empty =>
                if vazia = '1' then
                    nexts <= empty;
                end if;
        end case;
    end process;

    process(current)
    begin
        if current = filling then
            entrada_agua <= '1';
            aciona_motor <= '0';
            saida_agua <= '0';
        elsif current = full then
            entrada_agua <= '0';
            aciona_motor <= '1';
            saida_agua <= '0';
        elsif current = emptying then
            entrada_agua <= '0';
            aciona_motor <= '0';
            saida_agua <= '1';
        elsif current = empty then
            entrada_agua <= '0';
            aciona_motor <= '0';
            saida_agua <= '0';
        end if;       
    end process;
end architecture;