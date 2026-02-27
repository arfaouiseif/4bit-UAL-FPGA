----------------------------------------------------------------------------------
-- TESTBENCHES INDIVIDUELS POUR CHAQUE MODULE
-- Utile pour tester chaque composant séparément
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
-- 1. TESTBENCH pour l'addition
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu_addition_tb is
end alu_addition_tb;

architecture Behavioral of alu_addition_tb is
    component alu_addition
        Port ( 
            A : in STD_LOGIC_VECTOR (3 downto 0);
            B : in STD_LOGIC_VECTOR (3 downto 0);
            result : out STD_LOGIC_VECTOR (3 downto 0);
            carry : out STD_LOGIC;
            zero : out STD_LOGIC;
            sign : out STD_LOGIC
        );
    end component;
    
    signal A, B, result : STD_LOGIC_VECTOR(3 downto 0);
    signal carry, zero, sign : STD_LOGIC;
begin
    UUT: alu_addition port map (A => A, B => B, result => result, 
                                carry => carry, zero => zero, sign => sign);
    
    process
    begin
        report "Test Addition Module";
        
        -- Test 1: 5 + 3 = 8
        A <= "0101"; B <= "0011";
        wait for 10 ns;
        assert result = "1000" report "5+3 failed" severity error;
        assert carry = '0' report "5+3 carry failed" severity error;
        
        -- Test 2: 15 + 1 = 16 (overflow)
        A <= "1111"; B <= "0001";
        wait for 10 ns;
        assert result = "0000" report "15+1 result failed" severity error;
        assert carry = '1' report "15+1 carry failed" severity error;
        assert zero = '1' report "15+1 zero flag failed" severity error;
        
        -- Test 3: 7 + 7 = 14
        A <= "0111"; B <= "0111";
        wait for 10 ns;
        assert result = "1110" report "7+7 failed" severity error;
        
        report "Addition tests completed!";
        wait;
    end process;
end Behavioral;


----------------------------------------------------------------------------------
-- 2. TESTBENCH pour la soustraction
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu_soustraction_tb is
end alu_soustraction_tb;

architecture Behavioral of alu_soustraction_tb is
    component alu_soustraction
        Port ( 
            A : in STD_LOGIC_VECTOR (3 downto 0);
            B : in STD_LOGIC_VECTOR (3 downto 0);
            result : out STD_LOGIC_VECTOR (3 downto 0);
            carry : out STD_LOGIC;
            zero : out STD_LOGIC;
            sign : out STD_LOGIC
        );
    end component;
    
    signal A, B, result : STD_LOGIC_VECTOR(3 downto 0);
    signal carry, zero, sign : STD_LOGIC;
begin
    UUT: alu_soustraction port map (A => A, B => B, result => result,
                                    carry => carry, zero => zero, sign => sign);
    
    process
    begin
        report "Test Soustraction Module";
        
        -- Test 1: 10 - 3 = 7
        A <= "1010"; B <= "0011";
        wait for 10 ns;
        assert result = "0111" report "10-3 failed" severity error;
        assert carry = '0' report "10-3 no borrow expected" severity error;
        
        -- Test 2: 3 - 7 = -4 (negative)
        A <= "0011"; B <= "0111";
        wait for 10 ns;
        assert sign = '1' report "3-7 sign flag failed" severity error;
        
        -- Test 3: 5 - 5 = 0
        A <= "0101"; B <= "0101";
        wait for 10 ns;
        assert result = "0000" report "5-5 result failed" severity error;
        assert zero = '1' report "5-5 zero flag failed" severity error;
        
        report "Soustraction tests completed!";
        wait;
    end process;
end Behavioral;


----------------------------------------------------------------------------------
-- 3. TESTBENCH pour le registre à décalage
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_register_tb is
end shift_register_tb;

architecture Behavioral of shift_register_tb is
    component shift_register
        Port ( 
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            A : in STD_LOGIC_VECTOR (3 downto 0);
            B : in STD_LOGIC_VECTOR (3 downto 0);
            result : out STD_LOGIC_VECTOR (3 downto 0);
            carry : out STD_LOGIC;
            zero : out STD_LOGIC;
            sign : out STD_LOGIC
        );
    end component;
    
    signal clk, reset : STD_LOGIC := '0';
    signal A, B, result : STD_LOGIC_VECTOR(3 downto 0);
    signal carry, zero, sign : STD_LOGIC;
    constant clk_period : time := 10 ns;
begin
    UUT: shift_register port map (clk => clk, reset => reset, A => A, B => B,
                                  result => result, carry => carry, 
                                  zero => zero, sign => sign);
    
    clk_process: process
    begin
        clk <= '0'; wait for clk_period/2;
        clk <= '1'; wait for clk_period/2;
    end process;
    
    stim_proc: process
    begin
        report "Test Shift Register Module";
        
        -- Test 1: Décalage gauche logique
        reset <= '1'; wait for 20 ns; reset <= '0';
        A <= "1010";  -- 1010
        B <= "0000";  -- direction=0(left), mode=0(logical)
        wait for 30 ns;
        -- Après 1 cycle: 0100
        assert result = "0100" report "Left logical shift failed" severity error;
        
        -- Test 2: Décalage droite circulaire
        reset <= '1'; wait for 20 ns; reset <= '0';
        A <= "1101";  -- 1101
        B <= "0011";  -- direction=1(right), mode=1(circular)
        wait for 30 ns;
        -- Après 1 cycle: 1110 (LSB '1' va en MSB)
        assert result = "1110" report "Right circular shift failed" severity error;
        
        report "Shift register tests completed!";
        wait;
    end process;
end Behavioral;


----------------------------------------------------------------------------------
-- 4. TESTBENCH pour le compteur
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter_sync_tb is
end counter_sync_tb;

architecture Behavioral of counter_sync_tb is
    component counter_sync
        Port ( 
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            A : in STD_LOGIC_VECTOR (3 downto 0);
            B : in STD_LOGIC_VECTOR (3 downto 0);
            result : out STD_LOGIC_VECTOR (3 downto 0);
            carry : out STD_LOGIC;
            zero : out STD_LOGIC;
            sign : out STD_LOGIC
        );
    end component;
    
    signal clk, reset : STD_LOGIC := '0';
    signal A, B, result : STD_LOGIC_VECTOR(3 downto 0);
    signal carry, zero, sign : STD_LOGIC;
    constant clk_period : time := 10 ns;
begin
    UUT: counter_sync port map (clk => clk, reset => reset, A => A, B => B,
                                result => result, carry => carry,
                                zero => zero, sign => sign);
    
    clk_process: process
    begin
        clk <= '0'; wait for clk_period/2;
        clk <= '1'; wait for clk_period/2;
    end process;
    
    stim_proc: process
    begin
        report "Test Counter Module";
        
        -- Test 1: Comptage croissant de 0
        reset <= '1'; wait for 20 ns; reset <= '0';
        A <= "0000";  -- Start at 0
        B <= "0010";  -- enable=1, direction=0 (up)
        
        wait for 10 ns;
        assert result = "0000" report "Count start failed" severity error;
        
        wait for clk_period;
        assert result = "0001" report "Count up 1 failed" severity error;
        
        wait for clk_period;
        assert result = "0010" report "Count up 2 failed" severity error;
        
        -- Test 2: Comptage décroissant de 3
        reset <= '1'; wait for 20 ns; reset <= '0';
        A <= "0011";  -- Start at 3
        B <= "0011";  -- enable=1, direction=1 (down)
        
        wait for 10 ns;
        wait for clk_period;
        assert result = "0010" report "Count down to 2 failed" severity error;
        
        wait for clk_period;
        assert result = "0001" report "Count down to 1 failed" severity error;
        
        -- Test 3: Pause (enable=0)
        B <= "0001";  -- enable=0, direction=1
        wait for clk_period * 3;
        assert result = "0001" report "Counter should pause" severity error;
        
        report "Counter tests completed!";
        wait;
    end process;
end Behavioral;


----------------------------------------------------------------------------------
-- 5. TESTBENCH pour hex_to_7seg
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity hex_to_7seg_tb is
end hex_to_7seg_tb;

architecture Behavioral of hex_to_7seg_tb is
    component hex_to_7seg
        Port ( 
            hex_in : in STD_LOGIC_VECTOR (3 downto 0);
            seg_out : out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component;
    
    signal hex_in : STD_LOGIC_VECTOR(3 downto 0);
    signal seg_out : STD_LOGIC_VECTOR(6 downto 0);
begin
    UUT: hex_to_7seg port map (hex_in => hex_in, seg_out => seg_out);
    
    process
    begin
        report "Test Hex to 7-Segment Decoder";
        
        -- Test chaque chiffre
        hex_in <= "0000"; wait for 10 ns;  -- 0
        assert seg_out = "0000001" report "Display 0 failed" severity error;
        
        hex_in <= "0001"; wait for 10 ns;  -- 1
        assert seg_out = "1001111" report "Display 1 failed" severity error;
        
        hex_in <= "0010"; wait for 10 ns;  -- 2
        assert seg_out = "0010010" report "Display 2 failed" severity error;
        
        hex_in <= "1001"; wait for 10 ns;  -- 9
        assert seg_out = "0000100" report "Display 9 failed" severity error;
        
        hex_in <= "1010"; wait for 10 ns;  -- A
        assert seg_out = "0001000" report "Display A failed" severity error;
        
        hex_in <= "1111"; wait for 10 ns;  -- F
        assert seg_out = "0111000" report "Display F failed" severity error;
        
        report "7-segment decoder tests completed!";
        wait;
    end process;
end Behavioral;


----------------------------------------------------------------------------------
-- GUIDE D'UTILISATION DES TESTBENCHES INDIVIDUELS
----------------------------------------------------------------------------------
-- 
-- Ces testbenches permettent de tester chaque module INDIVIDUELLEMENT
-- avant de les intégrer dans l'UAL complète.
-- 
-- Pour utiliser :
-- 1. Copiez le testbench souhaité dans un nouveau fichier .vhd
-- 2. Ajoutez-le comme Simulation Source dans votre projet
-- 3. Lancez la simulation
-- 4. Vérifiez les assertions et les rapports dans la console
-- 
-- Avantages :
-- - Isolation des problèmes
-- - Tests plus rapides
-- - Débogage facilité
-- 
----------------------------------------------------------------------------------
