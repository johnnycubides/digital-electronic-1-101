format short eng % Formato de ingeniería
% format % para volver al formato científico

f = 0;
function ret = periodo(f)
  ret = 1 / f;
end

display(periodo(10e3));
