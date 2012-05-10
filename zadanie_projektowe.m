function zadanie_projektowe(model,obcinanie_wag,dlugosc_uczenie,dlugosc_walidacja,typ_sygnal_uczacy,typ_sygnal_walidujacy)
    % Zmienne wej�ciowe:
    %   obcinanie_wag - obliczamy siec z�o�on� z obci�tych wag
    %       0       - nie obcinamy wag
    %       1       - obcinamy wagi
    %   model - wyb�r modelu
    %       0       - model PePe
    %       1       - model Micha�
    %   dlugosc_uczenie - liczba probek do uczenia 
    %   dlugosc_walidacja - liczba probek do walidacji

    % zadanie_projektowe(0,100,100,typ_sygnal_uczacy,typ_sygnal_walidujacy)

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
    
    for net = 2 %1:length(NetDef)
        for n = 3
            NN = [n n 1];

    %         %% prezentacja ci�gu ucz�cego i waliduj�cego
    %         prezentuj_ciagi(u1,y1,u2,y2);

            %% uczenie sieci
            trparms = settrain;
            trparms = settrain(trparms,'maxiter',300,'D',1e-3,'skip',10);
            [W1,W2,NSSEvec]=feval('nnarx',cell2mat(NetDef(net)),NN,[],[],trparms,y1s,u1s);

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

        %         %% wyswietlenie wynikow koncowych
        %         f8=figure();
        %         plot(y2((n+1):dlugosc_walidacja)), hold on
        %         plot(yhat,'m--'), hold off
        %         title(strcat('Output (solid) and one-step ahead prediction (dashed) - ','nnarx'))
        %         xlabel('time(samples)')
        % 
        %         print(f8, '-dpng', strcat('y_prediction_','nnarx','_',walid_u{j}));
            end
        end
    end
    if obcinanie_wag == 1
        %% siec neuronowa z przycinanymi wagami
        %% ulepszenie dzialania przez przycinanie

        %% maksymalna liczba iteracji
        prparms = [50 0];

        %% przycinanie
        [thd,trv,fpev,tev,deff,pv] = nnprune('nnarx',NetDef,W1,W2,u1s,y1s,NN,trparms,prparms,u2s,y2s);

        %% minimum bledu testowania
        [mintev,index] = min(tev(pv));
        index=pv(index)

        %% budowa struktury sieci

        [W1,W2] = netstruc(NetDef,thd,index);

        %% ponowne trenowanie
        trparms = settrain(trparms,'D',0);
        [W1,W2,NSSEvec]=feval('nnarx',NetDef,NN,[],[],trparms,y1s,u1s);

        %% walidacja koncowej sieci
        %% przeskalowanie
        [w1,w2] = wrescale('nnarx',W1,W2,uscales,yscales,NN);

        %% generowanie ciagow
        [tmp,u2] = generowanie_ciagow(u1,u2,typ_sygnal_uczacy,typ_sygnal_walidujacy,dlugosc_uczenie,dlugosc_walidacja);

        %% wyj�cie modelu (ci�g waliduj�cy)
        y2 = obliczanie_wyjsc(u2,model);

        %% walidacja
        [yhat,NSSE_pruned,fig1,fig2,fig3] = nnvalid('nnarx',NetDef,NN,w1,w2,y2,u2);
        print(fig1, '-dpng', strcat('nnwalid1_pruned_','nnarx','_',typ_sygnal_walidujacy));
        print(fig2, '-dpng', strcat('nnwalid2_pruned_','nnarx','_',typ_sygnal_walidujacy));
        print(fig3, '-dpng', strcat('nnwalid3_pruned_','nnarx','_',typ_sygnal_walidujacy));

        %% wyswietlenie wynikow koncowych
        f333=figure(333);
        plot(y2((n+1):dlugosc_walidacja)), hold on
        plot(yhat,'m--'), hold off
        title(strcat('Output (solid) and one-step ahead prediction (dashed) - ','nnarx'))
        xlabel('time(samples)')

        print(f333, '-dpng', strcat('y_prediction_','nnarx','_',typ_sygnal_walidujacy));
    end
end


