function [ u1s, y1s, u2s, y2s, uscales, yscales] = skaluj_dane(u1, y1, u2, y2)

    [u1s, uscales] = dscale(u1);
    [y1s, yscales] = dscale(y1);
    
    u2s = dscale(u2, uscales);
    y2s = dscale(y2, yscales);   

end

