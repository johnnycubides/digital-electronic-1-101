format short eng % Formato de ingeniería
% format % para volver al formato científico

f = 0;
function ret = periodo(f)
  ret = 1 / f;
end

% display(periodo(10e3));

FREQ_IN = 12e6;
p = periodo(FREQ_IN);
display(p)

WIDTH_PULSE = 11e-6;

cnt = (FREQ_IN / (1 / WIDTH_PULSE)) / 2;
display(cnt);
