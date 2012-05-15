function [minNSSEvec,iter,NSSEvec_pruned,iter_pruned] = zadanie_projektowe(model,obcinanie_wag, ...
    rysuj_blad_uczenia,dlugosc_uczenie,dlugosc_walidacja,typ_sygnal_uczacy, ...
    typ_sygnal_walidujacy,typSieci,rzadModelu,typUczenia,paramD,paramCritMin)
    % Zmienne wej�ciowe:
    %   obcinanie_wag - obliczamy siec z�o�on� z obci�tych wag
    %       0       - nie obcinamy wag
    %       1       - obcinamy wagi
    %   model - wyb�r modelu
    %       0       - model PePe
    %       1       - model Micha�
    %   dlugosc_uczenie - liczba probek do uczenia 
    %   dlugosc_walidacja - liczba probek do walidacji

% [minNSSEvec,iter] = 
% zadanie_projektowe(0,1,0,500,200,'white','white',2,3,1,1e-3,1e-6)

    close all;
    set(0,'DefaultFigureWindowStyle','docked');
    load u;

    %% ci�g ucz�cy
    u1 = ones(1,dlugosc_uczenie); 

    %% ci�g waliduj�cy
    u2 = ones(1,dlugosc_walidacja);

    %% generowanie ciagow
    [u1,u2] = generowanie_ciagow(u1,u2,typ_sygnal_uczacy,typ_sygnal_walidujacy,dlugosc_uczenie,dlugosc_walidacja);

    %% wyj�cie modelu (ci�g uczacy)
    y1 = obliczanie_wyjsc(u1,model);

    %% wyj�cie modelu (ci�g waliduj�cy)
    y2 = obliczanie_wyjsc(u2,model);

    %% skalowanie danych
    [u1s, y1s, u2s, y2s, uscales, yscales] = skaluj_dane(u1, y1, u2, y2);

    %% okreslenie rzedu modelu
%     IO = 5;
%     OrderIndices = lipschit(u1, y1, 1:IO, 1:IO);
%     n = 3;% tyle wychodzi

    %% ustalenie struktury sieci
    
    NetDef1 = ['HHHHHHHHHHHH';'L-----------'];
    NetDef2 = ['HHHHHHHHHH';'L---------'];
    NetDef3 = ['HHHHHHHH';'L-------'];
    NetDef = {NetDef1; NetDef2; NetDef3};
    
    for net = typSieci %1:length(NetDef)
        for n = rzadModelu
            NN = [n n 1];

    %         %% prezentacja ci�gu ucz�cego i waliduj�cego
    %         prezentuj_ciagi(u1,y1,u2,y2);

            %% uczenie sieci
            trparms = settrain;
            if typUczenia == 1
                trparms = settrain(trparms,'maxiter',300,'D',paramD,'skip',10);
            elseif typUczenia == 2
                trparms = settrain(trparms,'maxiter',300,'skip',10,'critmin',paramCritMin);
            end
            
            [W1,W2,NSSEvec,iter]=feval('nnarx',cell2mat(NetDef(net)),NN,[],[],trparms,y1s,u1s);
            minNSSEvec = min(NSSEvec);
            
            if rysuj_blad_uczenia == 1
%                 figure(1001);
%                 plot(NSSEvec);
                return;
            end

            %% przeskalowanie wag
            [w1,w2] = wrescale('nnarx',W1,W2,uscales,yscales,NN);

            walid_u={w_white200 'white'; w_sinus200 'sinus'; w_prostokat200 'prostokat'; w_chirp200 'chirp'; w_step200 'step'};

            for j=1:length(walid_u)
                %% generowanie ciagow
                u2 = walid_u{j,1};

                %% wyj�cie modelu (ci�g waliduj�cy)
                y2 = obliczanie_wyjsc(u2,model);    

                %% walidacja nauczonej sieci
                [yhat,NSSE,fig1,fig2,fig3] = nnvalid('nnarx',cell2mat(NetDef(net)),NN,w1,w2,y2,u2);
                print(fig1, '-dpng', strcat('nnwalid1_','nnarx','_',walid_u{j,2},'_',int2str(n),'_','net',int2str(net)));
                print(fig2, '-dpng', strcat('nnwalid2_','nnarx','_',walid_u{j,2},'_',int2str(n),'_','net',int2str(net)));
                print(fig3, '-dpng', strcat('nnwalid3_','nnarx','_',walid_u{j,2},'_',int2str(n),'_','net',int2str(net)));
            end
            
            if obcinanie_wag == 1
                %% siec neuronowa z przycinanymi wagami
                %% ulepszenie dzialania przez przycinanie
                
                %% maksymalna liczba iteracji
                prparms = [50 0];
                
                %% przycinanie
                [thd,trv,fpev,tev,deff,pv] = nnprune('nnarx',cell2mat(NetDef(net)),W1,W2,u1s,y1s,NN,trparms,prparms,u2s,y2s);
                
                %% minimum bledu testowania
                [mintev,index] = min(tev(pv));
                index=pv(index);

                %% budowa struktury sieci
                [W1,W2] = netstruc(cell2mat(NetDef(net)),thd,index);

                %% ponowne uczenie sieci
                trparms = settrain(trparms,'D',0);
                [W1,W2,NSSEvec_pruned,iter_pruned]=feval('nnarx',cell2mat(NetDef(net)),NN,W1,W2,trparms,y1s,u1s);
                
                NSSEvec_pruned = min(NSSEvec_pruned);
                if rysuj_blad_uczenia == 1
    %                 figure(1001);
    %                 plot(NSSEvec);
                    return;
                end
                
                %% przeskalowanie
                [w1,w2] = wrescale('nnarx',W1,W2,uscales,yscales,NN);
                
                for j=1:length(walid_u)
                    %% generowanie ciagow
                    u2 = walid_u{j,1};

                    %% wyj�cie modelu (ci�g waliduj�cy)
                    y2 = obliczanie_wyjsc(u2,model);    

                    %% walidacja nauczonej sieci
                    [yhat,NSSE,fig1,fig2,fig3] = nnvalid('nnarx',cell2mat(NetDef(net)),NN,w1,w2,y2,u2);
                    print(fig1, '-dpng', strcat('nnwalid1_pruned','nnarx','_',walid_u{j,2},'_',int2str(n),'_','net',int2str(net)));
                    print(fig2, '-dpng', strcat('nnwalid2_pruned','nnarx','_',walid_u{j,2},'_',int2str(n),'_','net',int2str(net)));
                    print(fig3, '-dpng', strcat('nnwalid3_pruned','nnarx','_',walid_u{j,2},'_',int2str(n),'_','net',int2str(net)));
                end
            end
        end
    end
end



