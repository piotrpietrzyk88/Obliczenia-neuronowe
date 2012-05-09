function zadanie_projektowe(model,dlugosc_uczenie,dlugosc_walidacja,typ_sygnal_uczacy,typ_sygnal_walidujacy)
% Zmienne wej�ciowe:
%   model - wyb�r modelu
%       0     - model PePe
%       1     - model Micha�
%   dlugosc_uczenie - liczba probek do uczenia 
%   dlugosc_walidacja - liczba probek do walidacji

% zadanie_projektowe(0,100,100,typ_sygnal_uczacy,typ_sygnal_walidujacy)

close all;

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

%% prezentacja ci�gu ucz�cego i waliduj�cego
f1 = figure(1);
subplot(211)
plot(u1);
title('Ciag uczacy - wejscie systemu');
xlabel('t');
ylabel('u(t)');
subplot(212)
plot(y1);
title('Ciag uczacy - wyjscie systemu');
xlabel('t');
ylabel('y(t)');

print(f1, '-dpng', 'nlin_uczacy');

f2 = figure(2);
subplot(211)
plot(u2);
title('Ciag walidacyjny - wejscie systemu');
xlabel('t');
ylabel('u(t)');
subplot(212)
plot(y2);
title('Ciag walidacyjny - wyjscie systemu');
xlabel('t');
ylabel('y(t)');

print(f2, '-dpng', 'nlin_walid');

%% okreslenie rzedu modelu
% figure(3);
% N = length(u1);
% IO = floor(N*0.01);
% OrderIndices = lipschit(u1, y1, 1:IO, 1:IO);
n = 4;% tyle wychodzi

%% model liniowy
% 	[fig1,fig2]=dopasuj_liniowy(n, 'arx', u1, y1, u2, y2);
% 	print(fig1, '-dpng', strcat('dop_lin_walid','nnarx'));
% 	print(fig2, '-dpng', strcat('dop_lin_korel','nnarx'));

%% siec neuronowa

%% ustalenie struktury sieci
NetDef = ['HHHHHHHHHH';'L---------'];
NN = [n n 1];

%% uczenie sieci
trparms = settrain;
trparms = settrain(trparms,'maxiter',300,'D',1e-3,'skip',10);
[W1,W2,NSSEvec]=feval('nnarx',NetDef,NN,[],[],trparms,y1s,u1s);
	
%% przeskalowanie wag
[w1,w2] = wrescale('nnarx',W1,W2,uscales,yscales,NN);
        
%% walidacja nauczonej sieci
[yhat,NSSE,fig1,fig2,fig3] = nnvalid('nnarx',NetDef,NN,w1,w2,y2,u2);
print(fig1, '-dpng', strcat('nnwalid1_','nnarx','_',typ_sygnal_walidujacy));
print(fig2, '-dpng', strcat('nnwalid2_','nnarx','_',typ_sygnal_walidujacy));
print(fig3, '-dpng', strcat('nnwalid3_','nnarx','_',typ_sygnal_walidujacy));

%% wyswietlenie wynikow koncowych
f6=figure(6);
plot(y2((n+1):dlugosc_walidacja)), hold on
plot(yhat,'m--'), hold off
title(strcat('Output (solid) and one-step ahead prediction (dashed) - ','nnarx'))
xlabel('time(samples)')

print(f6, '-dpng', strcat('y_prediction_','nnarx','_',typ_sygnal_walidujacy));

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
f33=figure(33);
plot(y2((n+1):dlugosc_walidacja)), hold on
plot(yhat,'m--'), hold off
title(strcat('Output (solid) and one-step ahead prediction (dashed) - ','nnarx'))
xlabel('time(samples)')

print(f33, '-dpng', strcat('y_prediction_','nnarx','_',typ_sygnal_walidujacy));

end



