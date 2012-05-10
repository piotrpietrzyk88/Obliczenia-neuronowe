function [u1,u2] = generowanie_ciagow(u1,u2,typ_sygnal_uczacy,typ_sygnal_walidujacy,dlugosc_uczenie,dlugosc_walidacja)
    switch typ_sygnal_uczacy
        case 'white'
            for a=1:dlugosc_uczenie
                b=(rand()*2)-1;
                u1(a) = b;
            end   
        case 'sinus'
            for a=1:dlugosc_uczenie
                u1(a) = sin(a/5);
            end 
        case 'prostokat'
            N = dlugosc_uczenie/50;
            for a=1:dlugosc_uczenie
                if mod(a,N) == 0 || a == 1
                u1(a)=(rand()*2)-1;
                else
                    u1(a)=u1(a-1);
                end
            end   
        case 'chirp'
            for a=1:dlugosc_uczenie
                u1(a) = chirp(a/200,0,0.5,5);
            end 
        case 'step'
            u1(1:30) = -0.5;
            u1(31:dlugosc_uczenie)=0.5;
        otherwise
    %         nie ma takiego
    end

    switch typ_sygnal_walidujacy
        case 'white'
            for a=1:dlugosc_walidacja
                b=(rand()*2)-1;
                u2(a) = b;
            end   
        case 'sinus'
            for a=1:dlugosc_walidacja
                u2(a) = sin(a/5);
            end 
        case 'prostokat'
            N = dlugosc_walidacja/50;
            for a=1:dlugosc_walidacja
                if mod(a,N) == 0 || a == 1
                u2(a)=(rand()*2)-1;
                else
                    u2(a)=u2(a-1);
                end
            end   
        case 'chirp'
            for a=1:dlugosc_walidacja
                u2(a) = chirp(a/200,0,0.5,5);
            end 
        case 'step'
            u2(1:30) = 0;
            u2(31:dlugosc_walidacja)=0.5;
        otherwise
    %         nie ma takiego
    end
end