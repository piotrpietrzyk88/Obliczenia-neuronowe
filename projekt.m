clear all;
close all;

% model - wybór modelu
% 0     - model PePe
% 1     - model Micha³
model = 0;


% Training_Algorithm - wybór metody uczenia
% 1 - algorytm wstecznej propagacji
% 2 - rekursywna wersja wstecznej propagacji
% 3 - metoda Levenberga - Marquardta
% 4 - wersja metody Levenberga - Marquardta oszczêdzaj¹ca pamiêæ
% 5 - metoda Gaussa - Newtona
Training_Algorithm = 1;


% dlugosc - liczba probek do uczenia
dlugosc = 100;
% NetDef      - struktura sieci
% w1, w2      - wagi pocz¹tkowe
% U           - u
% Y           - y

U = ones(1,dlugosc)*rand();
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
% skip          - opusc tyle próbek
trparms = settrain(trparms,'maxiter',1000,'critmin',1e-8, 'eta',0.02,'skip',5);

w1 = [];
w2 = [];

NetDef=['HHHHHHHHHH';'L---------'];

IO = floor(dlugosc*0.01);
[OrderIndexMat]=lipschit(U,Y,1:IO,1:IO);

NN = [ 8 8 1 ];
[w1,w2,PI_vector,iteration,lambda]=nnarx(NetDef,NN,w1,w2,trparms,Y,U);



% switch Training_Algorithm
%     case 1
% %% batbp parameters
% %{    
% BATCH VERSION OF THE BACK-PROPAGATION ALGORITHM.
% 
%  Given a set of corresponding input-output pairs and an initial network
%  [W1,W2,critvec,iter]=batbp(NetDef,W1,W2,PHI,Y,trparms) trains the
%  network with backpropagation.
% 
%  The activation functions must be either linear or tanh. The network
%  architecture is defined by the matrix 'NetDef' consisting of two
%  rows. The first row specifies the hidden layer while the second
%  specifies the output layer.
% 
%  E.g.,    NetDef = ['LHHHH'
%                     'LL---']
% 
%  (L = Linear, H = tanh)
% 
%  Notice that the bias is included as the last column in the weight
%  matrices.
% 
%  See alternatively INCBP for the incremental/recursive back-propagation.
% 
% ==>[W1,W2,PI_vector,iter]=batbp(NetDef,W1,W2,PHI,Y,trparms)
% 
%  INPUT:
%  NetDef : Network definition 
%  W1     : Input-to-hidden layer weights. The matrix dimension is
%           dim(W1) = [(# of hidden units) * (inputs + 1)] (the 1 is due to the bias)
%           Use [] for a random initialization.
%  W2     : hidden-to-output layer weights.
%           dim(W2) = [(outputs)  *  (# of hidden units + 1)]
%           Use [] for a random initialization.
%  PHI    : Input vector. dim(PHI) = [(inputs)  *  (# of data)]
%  Y      : Output data. dim(Y) = [(outputs)  * (# of data)]
%  trparms: Data structure containing parameters associated with the
%           training algorithm (optional). Use the function SETTRAIN if
%           you do not want to use the default values.
% 
%  OUTPUT: 
%  W1, W2   : Weight matrices after training.
%  critvec  : Vector containing the criterion evaluated after each iteration.
%  iter     : # of iterations.
%  
%  Programmed by : Magnus Norgaard, IAU/IMM, DTU
%  LastEditDate  : Jan 15, 2000
% %}
% [W1,W2,crit_vector,iter]=batbp(NetDef,w1,w2,U,Y,trparms);
%     case 2
% %% incbp parameters
% %{
% RECURSIVE (=INCREMENTAL) VERSION OF THE BACKPROPAGATION ALGORITHM.
% 
%  Given a set of corresponding input-output pairs and an initial network
%  [W1,W2,critvec,iter]=INCBP(NetDef,W1,W2,PHI,Y,trparms) trains a
%  network with recursive backpropagation.
% 
%  The activation functions must be either linear or tanh. The network
%  architecture is determined by the matrix 'NetDef' consisting of two 
%  rows. The first row specifies the hidden layer while the second
%  specifies the output layer.
% 
%  E.g.,    NetDef = ['LHHHH'
%                     'LL---']
% 
%  (L = Linear, H = tanh)
% 
%  Notice that the bias is included as the last column in the weight
%  matrices.
% 
%  See alternatively BATBP for the batch version of back-propagation.
% 
% ==>[W1,W2,PI_vector,iter]=incbp(NetDef,W1,W2,PHI,Y,trparms)
% 
%  INPUT:
%  NetDef: Network definition 
%  W1    : Input-to-hidden layer weights. The matrix dimension is
%          dim(W1) = [(# of hidden units) * (inputs + 1)] (the 1 is due to the bias)
%          Use [] for a random initialization.
%  W2    : hidden-to-output layer weights.
%          dim(W2) = [(outputs)  *  (# of hidden units + 1)]
%          Use [] for a random initialization.
%  PHI   : Input vector. dim(PHI) = [(inputs)  *  (# of data)]
%  Y     : Output data. dim(Y) = [(outputs)  * (# of data)]
%  trparms: Data structure containing parameters associated with the
%           training algorithm (optional). Use the function SETTRAIN if
%           you do not want to use the default values.
% 
%  OUTPUT:
%  W1, W2   : Weight matrices after training.
%  critvec  : Vector containing the criterion evaluated after each iteration.
%  iter     : # of iterations.
% 
%  Programmed by : Magnus Norgaard, IAU/IMM, Technical University of Denmark
%  LastEditDate  : Jan. 15, 2000
% %}
% [W1,W2,crit_vector,iter]=incbp(NetDef,w1,w2,U,Y,trparms);
%     case 3
% %% marq parameters
% %{
% TRAIN A TWO LAYER NEURAL NETWORK WITH THE LEVENBERG-MARQUARDT METHOD.
% 
%          If desired, it is possible to use regularization by
%          weight decay. Also pruned (ie. not fully connected) networks can
%          be trained.
% 
%          Given a set of corresponding input-output pairs and an initial
%          network,
%          [W1,W2,critvec,iteration,lambda]=marq(NetDef,W1,W2,PHI,Y,trparms)
%          trains the network with the Levenberg-Marquardt method.
% 
%          The activation functions can be either linear or tanh. The
%          network architecture is defined by the matrix 'NetDef' which
%          has two rows. The first row specifies the hidden layer and the
%          second row specifies the output layer.
% 
%          E.g.:    NetDef = ['LHHHH' 
%                             'LL---']
%          (L = Linear, H = tanh)
% 
%          A weight is pruned by setting it to zero.
% 
%          The Marquardt method is described in:
%          K. Madsen: 'Optimering' (Haefte 38), IMM, DTU, 1991
%  
%          Notice that the bias is included as the last column in the weight
%          matrices.
% 
% ==>[W1,W2,PI_vector,iteration,lambda]=marq(NetDef,W1,W2,PHI,Y,trparms)
% 
%  INPUT:
%  NetDef : Network definition .
%  W1     : Input-to-hidden layer weights. The matrix dimension is
%           [(# of hidden units)-by-(inputs + 1)] (the 1 is due to the bias).
%           Use [] for a random initialization.
%  W2     : hidden-to-output layer weights. Dimension is
%           [(outputs)  *  (# of hidden units + 1)].
%           Use [] for a random initialization.
%  PHI    : Input vector. dim(PHI) = [(inputs)  *  (# of data)].
%  Y      : Output data. dim(Y) = [(outputs)  * (# of data)].
%  trparms: Data structure with parameters associated with the
%           training algorithm (optional). Use the function SETTRAIN if
%           you do not want to use the default values.
% 
%  OUTPUT:
%  W1, W2   : Weight matrices after training.
%  critvec:   Vector containing the criterion evaluated at each iteration
%  iteration: # of iterations
%  lambda   : The final value of lambda. Relevant only if retraining is desired
% 
%  Written by : Magnus Norgaard, IAU/IMM, Tecnical University of Denmark
%  LastEditDate  : Jan 15, 2000
% %}
% [W1,W2,crit_vector,iter,lambda]=marq(NetDef,w1,w2,U,Y,trparms);
%     case 4
% %% marqlm parameters
% %{
% LEVENBERG-MARQUARDT TRAINING ALGORITHM THAT USES LESS MEMORY
%      THAN MARQ BUT IS SLOWER. THE DIFFERENCE IN SPEED OCCURS BECAUSE
%      THE FUNCTION IS LESS 'VECTORIZED' (WHICH IS A MATLAB PROBLEM)
%      BUT ALSO BECAUSE SOME CALCULATIONS ARE MADE MORE THAN ONCE.
% 
% ==>[W1,W2,PI_vector,iteration,lambda]=marqlm(NetDef,W1,W2,PHI,Y,trparms)
% 
%  Written by : Magnus Norgaard, IAU/IMM, Technical Univ. of Denmark
%  LastEditDate  : January 15, 2000
% %}
% [W1,W2,crit_vector,iter,lambda]=marqlm(NetDef,w1,w2,U,Y,trparms);
%     case 5
% %% rpe parameters
% %{
% TRAIN A TWO LAYER NEURAL NETWORK WITH A RECURSIVE PREDICTION ERROR
%     ALGORITHM ("RECURSIVE GAUSS-NEWTON"). ALSO PRUNED (I.E., NOT FULLY
%     CONNECTED) NETWORKS CAN BE TRAINED.
% 
%          The activation functions can either be linear or tanh. The network
%          architecture is defined by the matrix 'NetDef', which has of two
%          rows. The first row specifies the hidden layer while the second
%          specifies the output layer.
% 
%          E.g.:    NetDef = ['LHHHH'
%                             'LL---']
% 
%          (L = linear, H = tanh)
% 
%          A weight is pruned by setting it to zero.
% 
%          The algorithm is described in:
%          L. Ljung: "System Identification - Theory for the User"
%          (Prentice-Hall, 1987)
% 
%          Notice that the bias is included as the last column
%          in the weight matrices.
% 
%  CALL:
%            [W1,W2,critvec,iter]=rpe(NetDef,W1,W2,PHI,Y,trparms)
% 
%  INPUT:
%  NetDef: Network definition 
%  W1    : Input-to-hidden layer weights. The matrix dimension is
%          dim(W1) = [(# of hidden units) * (inputs + 1)] (the 1 is due to the bias)
%          Use [] for a random initialization.
%  W2    : hidden-to-output layer weights.
%          dim(W2) = [(outputs)  *  (# of hidden units + 1)]
%          Use [] for a random initialization.
%  PHI   : Input vector. dim(PHI) = [(inputs)  *  (# of data)]
%  Y     : Output data. dim(Y) = [(outputs)  * (# of data)]
%  trparms: Data structure with parameters associated with the
%           training algorithm (optional). Use the function SETTRAIN if
%           you do not want to use the default values. 
% 
%  OUTPUT:
%  W1, W2    : Weight matrices after training
%  critvec   : Vector containing the criterion of fit after each iteration
%  iter      : # of iterations
%  
%  Programmed by : Magnus Norgaard, IAU/IMM, Technical University of Denmark 
%  LastEditDate  : January 15, 2000
% %}
% [W1,W2,crit_vector,iter]=rpe(NetDef,w1,w2,U,Y,trparms);
% end