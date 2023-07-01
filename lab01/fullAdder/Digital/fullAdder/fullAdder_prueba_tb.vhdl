--  A testbench for fullAdder_prueba_tb
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity fullAdder_prueba_tb is
end fullAdder_prueba_tb;

architecture behav of fullAdder_prueba_tb is
  component main
    port (
      b: in std_logic;
      a: in std_logic;
      ci: in std_logic;
      co: out std_logic;
      s: out std_logic);
  end component;

  signal b : std_logic;
  signal a : std_logic;
  signal ci : std_logic;
  signal co : std_logic;
  signal s : std_logic;
  function to_string ( a: std_logic_vector) return string is
      variable b : string (1 to a'length) := (others => NUL);
      variable stri : integer := 1; 
  begin
      for i in a'range loop
          b(stri) := std_logic'image(a((i)))(2);
      stri := stri+1;
      end loop;
      return b;
  end function;
begin
  main_0 : main port map (
    b => b,
    a => a,
    ci => ci,
    co => co,
    s => s );
  process
    type pattern_type is record
      ci : std_logic;
      a : std_logic;
      b : std_logic;
      s : std_logic;
      co : std_logic;
    end record;
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array := (
      ('1', '1', '1', '1', '1'));
  begin
    for i in patterns'range loop
      b <= patterns(i).b;
      a <= patterns(i).a;
      ci <= patterns(i).ci;
      wait for 10 ns;
      assert std_match(co, patterns(i).co) OR (co = 'Z' AND patterns(i).co = 'Z')
        report "wrong value for co, i=" & integer'image(i)
         & ", expected " & std_logic'image(patterns(i).co) & ", found " & std_logic'image(co) severity error;assert std_match(s, patterns(i).s) OR (s = 'Z' AND patterns(i).s = 'Z')
        report "wrong value for s, i=" & integer'image(i)
         & ", expected " & std_logic'image(patterns(i).s) & ", found " & std_logic'image(s) severity error;end loop;
    wait;
  end process;
end behav;
