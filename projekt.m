clear all;
close all;

% model - wyb�r modelu
% 0     - model PePe
% 1     - model Micha�
model = 0;

% NetDef      - struktura sieci
% w1, w2      - wagi pocz�tkowe
% U           - u
% Y           - y

U = ones(1,100)*rand();
x = zeros(1,length(U));
x1 = zeros(1,length(U));
x2 = zeros(1,length(U));
Y = zeros(1,length(U));
x1(1) = 0;
x2(1) = U(1);


if model == 0
    for k = 1:length(U)
        x1(k+1) = 0.5*x2(k) + 0.2*x1(k)*x2(k);
        x2(k+1) = -0.3*x1(k) + 0.8*x2(k) + U(k);
        Y(k) = x1(k) + (x2(k))^2;
    end
elseif model == 1
    for k = 1:length(U)
        x(k+1) = x(k) + U(k);
        Y(k) = (x(k))^2;
    end   
    
end


%% settrain parameters 
trparms = settrain; % Set trparms to default
% maxiter       - maksymalna liczba iteracji
% critmin       - kryterium stopu
% eta           - krok
% skip          - opusc tyle pr�bek
trparms = settrain(trparms,'maxiter',1000,'critmin',1e-4, 'eta',0.02,'skip',5);

w1 = [];
w2 = [];
NN = [ 3 3 1 ];
NetDef=['HHHHHH';'H-----'];


%% batbp parameters 
% W1, W2        - wagi nauczonej sieci
% crit_vector   - wektor b��d�w w kolejnych iteracjach
% iter          - aktualna liczba iteracji
[W1,W2,crit_vector,iter]=batbp(NetDef,w1,w2,U,Y,trparms);

[W1,W2, NSSEvec,iter,lambda]=nnarx(NetDef,NN,W1,W2,trparms,Y,U);

%% marq parameters

% W1, W2        - wagi nauczonej sieci
% crit_vector   - wektor b��d�w w kolejnych iteracjach
% iter          - aktualna liczba iteracji
[W1,W2,crit_vector,iter,lambda]=marq(NetDef,w1,w2,PHI,Y,trparms);