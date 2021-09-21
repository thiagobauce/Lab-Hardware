library ieee;
use ieee.std_logic_1164.all;

entity shiftrotater is
    port (
        din:    in std_logic_vector(3 downto 0);
        desloc: in std_logic_vector(1 downto 0);
        shift:  in std_logic;
        dout:   out std_logic_vector(3 downto 0)
    );
end entity;

architecture structural of shiftrotater is

    signal x : std_logic_vector(0 TO 3);
    signal y : std_logic_vector(0 TO 3);
    signal sh : std_logic_vector(0 TO 3);

    function bitval(test : BOOLEAN) return std_ulogic is
    begin
        if test then 
            RETURN ('1');
        else
            RETURN ('0');
        end if;
    end function bitval;
    
    begin
    
        seta : process (shift, desloc)
        begin
            sh(0) <= shift AND bitval(desloc > "00");
            sh(1) <= shift AND bitval(desloc > "01");
            sh(2) <= shift AND bitval(desloc > "10");
            sh(3) <= shift AND bitval(desloc > "11");
        end process seta;

        mux00 : entity work.mux2(behavioral)
            port map(din(0), din(3), desloc(0), x(0));
        mux01 : entity work.mux2(behavioral)
            port map(din(1), din(0), desloc(0), x(1));
        mux02 : entity work.mux2(behavioral)
            port map(din(2), din(1), desloc(0), x(2));
        mux03 : entity work.mux2(behavioral)
            port map(din(3), din(2), desloc(0), x(3));
    

        mux10 : entity work.mux2(behavioral)
            port map(x(0), x(2), desloc(1), y(0));
        mux11 : entity work.mux2(behavioral)
            port map(x(1), x(3), desloc(1), y(1));
        mux12 : entity work.mux2(behavioral)
            port map(x(2), x(0), desloc(1), y(2));
        mux13 : entity work.mux2(behavioral)
            port map(x(3), x(1), desloc(1), y(3));

        mux20 : entity work.mux2(behavioral)
            port map(y(0), '0', sh(0), dout(0));
        mux21 : entity work.mux2(behavioral)
            port map(y(1), '0', sh(1), dout(1));
        mux22 : entity work.mux2(behavioral)
            port map(y(2), '0', sh(2), dout(2));
        mux23 : entity work.mux2(behavioral)
            port map(y(3), '0', sh(3), dout(3));
            
end architecture;
