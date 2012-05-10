
            for a=1:dlugosc_walidacja
                u2(a) = chirp(a/200,0,0.5,5);
            end 

            u1(1:30) = 0;
            u1(31:dlugosc_walidacja)=0.5;