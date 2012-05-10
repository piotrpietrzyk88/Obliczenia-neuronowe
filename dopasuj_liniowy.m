function [f5,f6] = dopasuj_liniowy( n, model, u1, y1, u2, y2)

% dopasowanie modelu liniowego

if strcmp('oe', model)    
    th = oe([y1' u1'], [n n 1]);
elseif strcmp('arx', model)
    th = arx([y1' u1'], [n n 1]);
else
    'Error';
end
    
present(th);

f5 = figure(5);
compare([y2' u2'], th,1);
print(f5, '-djpeg', 'image5');


f6 = figure(6);
resid([y2' u2'],th, 'CORR', 500);
print(f6, '-djpeg', 'image6');


end

