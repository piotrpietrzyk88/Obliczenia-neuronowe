function [u1,u2] = generowanie_ciagow(u1,u2,typ_sygnal_uczacy,typ_sygnal_walidujacy,dlugosc_uczenie,dlugosc_walidacja)
    switch typ_sygnal_uczacy
        case 'random'
            for a=1:dlugosc_uczenie
                b=(rand()*2)-1;
                u1(a) = b;
            end   
        otherwise
    %         nie ma takiego
    end

    switch typ_sygnal_walidujacy
        case 'random'
            for a=1:dlugosc_walidacja
                b=(rand()*2)-1;
                u2(a) = b;
            end 
        otherwise
    %         nie ma takiego
    end
end