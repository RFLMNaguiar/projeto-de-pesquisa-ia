%% Q-learning with epsilon-greedy exploration Algorithm for Deterministic Cleaning Robot V1
%  Matlab code : Reza Ahmadzadeh
%  email: reza.ahmadzadeh@iit.it
%  March-2014
%% The deterministic cleaning-robot MDP
% a cleaning robot has to collect a used can also has to recharge its
% batteries. the state describes the position of the robot and the action
% describes the direction of motion. The robot can move to the left or to
% the right. The first (1) and the final (6) states are the terminal
% states. The goal is to find an optimal policy that maximizes the return
% from any initial state. Here the Q-learning epsilon-greedy exploration
% algorithm (in Reinforcement learning) is used.
% Algorithm 2-3, from:
% @book{busoniu2010reinforcement,
%   title={Reinforcement learning and dynamic programming using function approximators},
%   author={Busoniu, Lucian and Babuska, Robert and De Schutter, Bart and Ernst, Damien},
%   year={2010},
%   publisher={CRC Press}
% }
% notice: the code is written in 1-indexed instead of 0-indexed
%
% V1 the initial evaluation of the algorithm 
%
%% this is the main function including the initialization and the algorithm
% the inputs are: initial Q matrix, set of actions, set of states,
% discounting factor, learning rate, exploration probability,
% number of iterations, and the initial state.
function qlearning
global vetor_r vetor_est;
%cria usuarios aleatorios no espaço 25 150
episodio=10;
numepisodio=1;
while numepisodio<=episodio
nusers=100;
Pt=23;
f=3.5;

for i=1:nusers
    users1(i,1)=[randi(150,1,1)];
    users1(i,2)=[randi(150,1,1)];
end;

% users1(:,1)=[
%     24
%     85
%    146
%     31
%     55
%     90
%     13
%     70
%     21
%     38
%     73
%    109
%     27
%     50
%     81
%     38
%     13
%     89
%     77
%     43
%     67
%    103
%      4
%    143
%     17
%     20
%     78
%    111
%    143
%     85
%     95
%    107
%      9
%    140
%     28
%     64
%     16
%     57
%     65
%      7
%      3
%     96
%    137
%     45
%     66
%    134
%     21
%    103
%     43
%    132
%     86
%     62
%    105
%    134
%     40
%    143
%     20
%     28
%     95
%    126
%    143
%     66
%    112
%     83
%    127
%     72
%    108
%    122
%     70
%     86
%     20
%     12
%    147
%     16
%    100
%    130
%    127
%     86
%     19
%    146
%     49
%     52
%     89
%     40
%    108
%    127
%     46
%     31
%     31
%     41
%     99
%     91
%    120
%     25
%    123
%     62
%     48
%     79
%     69
%    133];
%     
% users1(:,2)=[81
%     78
%     34
%     29
%     74
%    136
%    122
%     15
%     32
%     37
%      6
%    130
%    147
%      4
%     50
%     11
%     78
%    113
%     84
%    118
%    129
%     80
%    107
%     37
%      6
%    146
%     89
%     80
%     58
%     16
%     56
%    108
%    134
%    129
%     47
%     61
%     42
%    150
%     41
%      2
%     15
%      8
%     60
%     76
%      9
%    149
%    106
%    140
%     68
%     30
%     61
%     29
%    106
%     25
%     63
%    108
%    138
%     44
%     10
%    134
%     54
%    117
%    115
%    118
%     78
%     66
%    113
%    140
%    147
%     53
%     79
%     87
%    143
%     64
%    122
%    116
%    114
%     91
%     51
%     77
%     83
%     97
%     62
%     21
%     69
%      6
%     13
%     18
%    141
%     24
%     63
%     22
%    117
%     37
%    133
%     88
%    110
%    105
%     58
%     99];
figure(1)
plot(users1(:,1),users1(:,2),'.b');
hold on
% learning parameters
gamma = 0.5;    % discount factor  % TODO : we need learning rate schedule
alpha = 0.5;    % learning rate    % TODO : we need exploration rate schedule
epsilon = 0.9;  % exploration probability (1-epsilon = exploit / epsilon = explore)
% states
state = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36];%[0,1,2,3,4,5];
vetor_Estados=[25 25;25 50;25 75;25 100;25 125;25 150;50 25;50 50;50 75;50 100;50 125;50 150;75 25;75 50;75 75;75 100;75 125; 75 150;100 25;100 50;100 75;100 100;100 125;100 150;125 25;125 50;125 75;125 100;125 125;125 150;150 25;150 50;150 75;150 100;150 125;150 150];
         
% actions
action = [1 2 3 4 5];%[-1,1];
vetor_Acoes=[0 0;25 0;-25 0;0 25;0 -25];

% initial Q matrix
Q = zeros(length(state),length(action));
K = 1000;     % maximum number of the iterations
state_idx = 3;  % the initial state to begin from
figure(1)
 plot(vetor_Estados(state_idx,1),vetor_Estados(state_idx,2),'-*b');
hold on
vetor_plotfinal(1,:)=[vetor_Estados(state_idx,1),vetor_Estados(state_idx,2)];

%% the main loop of the algorithm
for k = 1:K
    disp(['iteration: ' num2str(k)]);
    r=rand; % get 1 uniform random number
    x=sum(r>=cumsum([0, 1-epsilon, epsilon])); % check it to be in which probability area
    
    % choose either explore or exploit
    if x == 1   % exploit
        [~,umax]=max(Q(state_idx,:));
        current_action = action(umax);
    else        % explore
        current_action=datasample(action,1); % choose 1 action randomly (uniform random distribution)
    end
    
    action_idx = find(action==current_action); % id of the chosen action
    % observe the next state and next reward ** there is no reward matrix
    [next_state,next_reward] = model(state(state_idx),action(action_idx),vetor_Estados, vetor_Acoes,users1,Pt,f,k);
    next_state_idx = find(state==next_state);  % id of the next state
    % print the results in each iteration
    disp(['current state : ' num2str(state(state_idx)) ' next state : ' num2str(state(next_state_idx)) ' taken action : ' num2str(action(action_idx))]);
    disp([' next reward : ' num2str(next_reward)]);
    % update the Q matrix using the Q-learning rule
    Q(state_idx,action_idx) = Q(state_idx,action_idx) + alpha * (next_reward + gamma* max(Q(next_state_idx,:)) - Q(state_idx,action_idx));
    vetor_recompensa(state_idx,action_idx)=next_reward;
    
    % if the robot is stuck in terminals
    if (next_state_idx == length(vetor_Estados) || next_state_idx == 1)
        state_idx = datasample(2:length(state)-1,1); % we just restart the episode with a new state
    else
        state_idx = next_state_idx;
    end
    disp(Q);  % display Q in each level
    figure(1)
%     plot(vetor_Estados(state_idx,1),vetor_Estados(state_idx,2),'pb');
%     hold on
    vetor_plotfinal(k+1,:)=[vetor_Estados(state_idx,1),vetor_Estados(state_idx,2)];
    plot(vetor_plotfinal(k+1,1),vetor_plotfinal(k+1,2),'-*k');
    hold on
end

% figure(3)
%     for jj=1:length(vetor_plotfinal)
%     plot(vetor_plotfinal(jj,1),vetor_plotfinal(jj,2),'-*k');
%  legend('Users','Trajectory');
%     end;

% display the final Q matrix
disp('Final Q matrix : ');
disp(Q)
[C,I]=max(Q,[],2);                              % finding the max values
disp('Q(optimal):');
disp(C);
disp('Optimal Policy');
disp('*');
for aa=1:length(I)
disp([action(I(aa,1));]);
end;
disp('*');

figure(1)
[valor ind]=max(C)
plot(vetor_Estados(ind,1),vetor_Estados(ind,2),'or')
vetor_recompensa
vetor_recompensa(ind)
% anteriorx=vetor_Estados(3,1);
% anteriory=vetor_Estados(3,2);
%      for jj=2:(length(I)-1)
%          anteriorx=anteriorx+vetor_Acoes(I(jj),1);
%          anteriory=anteriory+ vetor_Acoes(I(jj),2);
%         plot(anteriorx,anteriory,'Or');
%         hold on
%      end;
grid

[maior_retorno indd]=max(vetor_r)
melhor_estado=vetor_est(indd)

figure(1)
plot(vetor_Estados(melhor_estado,1),vetor_Estados(melhor_estado,2),'oc', 'LineWidth',4)
%legend('Users','Drones')

vetor_acumuladooutage(numepisodio)=((nusers-maior_retorno)/nusers)*100;
numepisodio=numepisodio+1;
end;
figure(3)
plot(1:episodio,vetor_acumuladooutage,'-*k');
xlabel('Episode Number');
ylabel('% of Users in Outage');
legend('% of Users in Outage');
axis([0 10 0 100])
grid
end
%% This function is used as an observer to give the next state and the next reward using the current state and action
function [next_state,r] = model(x,u,vetor_Estados,vetor_Acoes,users1,Pt,f,k)
global vetor_r vetor_est;
if (vetor_Estados(x,1) < 150 || vetor_Estados(x,2) <150)
novo_Estado_x=vetor_Estados(x,1)+vetor_Acoes(u,1);
novo_Estado_y=vetor_Estados(x,2)+vetor_Acoes(u,2);
if novo_Estado_x>150||novo_Estado_x<25||novo_Estado_y<25||novo_Estado_y>150
    u=1;
    novo_Estado_x=vetor_Estados(x,1)+vetor_Acoes(u,1);
    novo_Estado_y=vetor_Estados(x,2)+vetor_Acoes(u,1);
end;
[tempx1 tempy1]=find(vetor_Estados==novo_Estado_x);
[tempx2 tempy2]=find(vetor_Estados==novo_Estado_y);
parx1y1=[tempx1 tempy1];
parx2y2=[tempx2 tempy2];
for ui=1:length(parx1y1)
     if parx1y1(ui,2)==1
           tpx1(ui,1)=parx1y1(ui,1);
           tpy1(ui,2)=parx1y1(ui,2);
     end;
end;
uy=1;
for ui=1:length(parx2y2)
     if parx2y2(ui,2)==2
           tpx2(uy,1)=parx2y2(ui,1);
           tpy2(uy,2)=parx2y2(ui,2);
           uy=uy+1;
     end;
end;
for i=1:length(tpx1)
    for j=1:length(tpx2)
        if tpx1(i,1)==tpx2(j,1)
            next_state=tpx1(i,1);
        end;
    end;
end;

else
    if vetor_Estados(x,1)==150 && vetor_Estados(x,2)==150
    while u==2||u==4
        u=randi(5,1,1);
    end;
    
    novo_Estado_x=vetor_Estados(x,1)+vetor_Acoes(u,1);
novo_Estado_y=vetor_Estados(x,2)+vetor_Acoes(u,2);
if novo_Estado_x>150||novo_Estado_x<25||novo_Estado_y<25||novo_Estado_y>150
    u=1;
    novo_Estado_x=vetor_Estados(x,1)+vetor_Acoes(u,1);
    novo_Estado_y=vetor_Estados(x,2)+vetor_Acoes(u,1);
end;
[tempx1 tempy1]=find(vetor_Estados==novo_Estado_x);
[tempx2 tempy2]=find(vetor_Estados==novo_Estado_y);
parx1y1=[tempx1 tempy1];
parx2y2=[tempx2 tempy2];
for ui=1:length(parx1y1)
     if parx1y1(ui,2)==1
           tpx1(ui,1)=parx1y1(ui,1);
           tpy1(ui,2)=parx1y1(ui,2);
     end;
end;
uy=1;
for ui=1:length(parx2y2)
     if parx2y2(ui,2)==2
           tpx2(uy,1)=parx2y2(ui,1);
           tpy2(uy,2)=parx2y2(ui,2);
           uy=uy+1;
     end;
end;
for i=1:length(tpx1)
    for j=1:length(tpx2)
        if tpx1(i,1)==tpx2(j,1)
            next_state=tpx1(i,1);
        end;
    end;
end;

    
else if vetor_Estados(x,1)==150 && vetor_Estados(x,2)==25
        while u==2||u==5
        u=randi(5,1,1);
         end;
    
        novo_Estado_x=vetor_Estados(x,1)+vetor_Acoes(u,1);
novo_Estado_y=vetor_Estados(x,2)+vetor_Acoes(u,2);
if novo_Estado_x>150||novo_Estado_x<25||novo_Estado_y<25||novo_Estado_y>150
    u=1;
    novo_Estado_x=vetor_Estados(x,1)+vetor_Acoes(u,1);
    novo_Estado_y=vetor_Estados(x,2)+vetor_Acoes(u,1);
end;
[tempx1 tempy1]=find(vetor_Estados==novo_Estado_x);
[tempx2 tempy2]=find(vetor_Estados==novo_Estado_y);
parx1y1=[tempx1 tempy1];
parx2y2=[tempx2 tempy2];
for ui=1:length(parx1y1)
     if parx1y1(ui,2)==1
           tpx1(ui,1)=parx1y1(ui,1);
           tpy1(ui,2)=parx1y1(ui,2);
     end;
end;
uy=1;
for ui=1:length(parx2y2)
     if parx2y2(ui,2)==2
           tpx2(uy,1)=parx2y2(ui,1);
           tpy2(uy,2)=parx2y2(ui,2);
           uy=uy+1;
     end;
end;
for i=1:length(tpx1)
    for j=1:length(tpx2)
        if tpx1(i,1)==tpx2(j,1)
            next_state=tpx1(i,1);
        end;
    end;
end;

else if vetor_Estados(x,1)==25 && vetor_Estados(x,2)==25
        while u==3||u==5
        u=randi(5,1,1);
         end;
    
    novo_Estado_x=vetor_Estados(x,1)+vetor_Acoes(u,1);
novo_Estado_y=vetor_Estados(x,2)+vetor_Acoes(u,2);
if novo_Estado_x>150||novo_Estado_x<25||novo_Estado_y<25||novo_Estado_y>150
    u=1;
    novo_Estado_x=vetor_Estados(x,1)+vetor_Acoes(u,1);
    novo_Estado_y=vetor_Estados(x,2)+vetor_Acoes(u,1);
end;
[tempx1 tempy1]=find(vetor_Estados==novo_Estado_x);
[tempx2 tempy2]=find(vetor_Estados==novo_Estado_y);
parx1y1=[tempx1 tempy1];
parx2y2=[tempx2 tempy2];
for ui=1:length(parx1y1)
     if parx1y1(ui,2)==1
           tpx1(ui,1)=parx1y1(ui,1);
           tpy1(ui,2)=parx1y1(ui,2);
     end;
end;
uy=1;
for ui=1:length(parx2y2)
     if parx2y2(ui,2)==2
           tpx2(uy,1)=parx2y2(ui,1);
           tpy2(uy,2)=parx2y2(ui,2);
           uy=uy+1;
     end;
end;
for i=1:length(tpx1)
    for j=1:length(tpx2)
        if tpx1(i,1)==tpx2(j,1)
            next_state=tpx1(i,1);
        end;
    end;
end;

else if vetor_Estados(x,1)==25 && vetor_Estados(x,2)==150
        while u==3||u==4
        u=randi(5,1,1);
         end;
    
    novo_Estado_x=vetor_Estados(x,1)+vetor_Acoes(u,1);
novo_Estado_y=vetor_Estados(x,2)+vetor_Acoes(u,2);
if novo_Estado_x>150||novo_Estado_x<25||novo_Estado_y<25||novo_Estado_y>150
    u=1;
    novo_Estado_x=vetor_Estados(x,1)+vetor_Acoes(u,1);
    novo_Estado_y=vetor_Estados(x,2)+vetor_Acoes(u,1);
end;
[tempx1 tempy1]=find(vetor_Estados==novo_Estado_x);
[tempx2 tempy2]=find(vetor_Estados==novo_Estado_y);
parx1y1=[tempx1 tempy1];
parx2y2=[tempx2 tempy2];
for ui=1:length(parx1y1)
     if parx1y1(ui,2)==1
           tpx1(ui,1)=parx1y1(ui,1);
           tpy1(ui,2)=parx1y1(ui,2);
     end;
end;
uy=1;
for ui=1:length(parx2y2)
     if parx2y2(ui,2)==2
           tpx2(uy,1)=parx2y2(ui,1);
           tpy2(uy,2)=parx2y2(ui,2);
           uy=uy+1;
     end;
end;
for i=1:length(tpx1)
    for j=1:length(tpx2)
        if tpx1(i,1)==tpx2(j,1)
            next_state=tpx1(i,1);
        end;
    end;
end;

else if vetor_Estados(x,1)==150 && vetor_Estados(x,2)<150
        while u==2
        u=randi(5,1,1);
         end;
    
    novo_Estado_x=vetor_Estados(x,1)+vetor_Acoes(u,1);
novo_Estado_y=vetor_Estados(x,2)+vetor_Acoes(u,2);
if novo_Estado_x>150||novo_Estado_x<25||novo_Estado_y<25||novo_Estado_y>150
    u=1;
    novo_Estado_x=vetor_Estados(x,1)+vetor_Acoes(u,1);
    novo_Estado_y=vetor_Estados(x,2)+vetor_Acoes(u,1);
end;
[tempx1 tempy1]=find(vetor_Estados==novo_Estado_x);
[tempx2 tempy2]=find(vetor_Estados==novo_Estado_y);
parx1y1=[tempx1 tempy1];
parx2y2=[tempx2 tempy2];
for ui=1:length(parx1y1)
     if parx1y1(ui,2)==1
           tpx1(ui,1)=parx1y1(ui,1);
           tpy1(ui,2)=parx1y1(ui,2);
     end;
end;
uy=1;
for ui=1:length(parx2y2)
     if parx2y2(ui,2)==2
           tpx2(uy,1)=parx2y2(ui,1);
           tpy2(uy,2)=parx2y2(ui,2);
           uy=uy+1;
     end;
end;
for i=1:length(tpx1)
    for j=1:length(tpx2)
        if tpx1(i,1)==tpx2(j,1)
            next_state=tpx1(i,1);
        end;
    end;
end;

    else if vetor_Estados(x,1)<150 && vetor_Estados(x,2)==25
        while u==5
        u=randi(5,1,1);
         end;
    
        novo_Estado_x=vetor_Estados(x,1)+vetor_Acoes(u,1);
novo_Estado_y=vetor_Estados(x,2)+vetor_Acoes(u,2);
if novo_Estado_x>150||novo_Estado_x<25||novo_Estado_y<25||novo_Estado_y>150
    u=1;
    novo_Estado_x=vetor_Estados(x,1)+vetor_Acoes(u,1);
    novo_Estado_y=vetor_Estados(x,2)+vetor_Acoes(u,1);
end;
[tempx1 tempy1]=find(vetor_Estados==novo_Estado_x);
[tempx2 tempy2]=find(vetor_Estados==novo_Estado_y);
parx1y1=[tempx1 tempy1];
parx2y2=[tempx2 tempy2];
for ui=1:length(parx1y1)
     if parx1y1(ui,2)==1
           tpx1(ui,1)=parx1y1(ui,1);
           tpy1(ui,2)=parx1y1(ui,2);
     end;
end;
uy=1;
for ui=1:length(parx2y2)
     if parx2y2(ui,2)==2
           tpx2(uy,1)=parx2y2(ui,1);
           tpy2(uy,2)=parx2y2(ui,2);
           uy=uy+1;
     end;
end;
for i=1:length(tpx1)
    for j=1:length(tpx2)
        if tpx1(i,1)==tpx2(j,1)
            next_state=tpx1(i,1);
        end;
    end;
end;

else if vetor_Estados(x,1)==25 && vetor_Estados(x,2)<150
        while u==3
        u=randi(5,1,1);
         end;
    
        novo_Estado_x=vetor_Estados(x,1)+vetor_Acoes(u,1);
novo_Estado_y=vetor_Estados(x,2)+vetor_Acoes(u,2);
if novo_Estado_x>150||novo_Estado_x<25||novo_Estado_y<25||novo_Estado_y>150
    u=1;
    novo_Estado_x=vetor_Estados(x,1)+vetor_Acoes(u,1);
    novo_Estado_y=vetor_Estados(x,2)+vetor_Acoes(u,1);
end;
[tempx1 tempy1]=find(vetor_Estados==novo_Estado_x);
[tempx2 tempy2]=find(vetor_Estados==novo_Estado_y);
parx1y1=[tempx1 tempy1];
parx2y2=[tempx2 tempy2];
for ui=1:length(parx1y1)
     if parx1y1(ui,2)==1
           tpx1(ui,1)=parx1y1(ui,1);
           tpy1(ui,2)=parx1y1(ui,2);
     end;
end;
uy=1;
for ui=1:length(parx2y2)
     if parx2y2(ui,2)==2
           tpx2(uy,1)=parx2y2(ui,1);
           tpy2(uy,2)=parx2y2(ui,2);
           uy=uy+1;
     end;
end;
for i=1:length(tpx1)
    for j=1:length(tpx2)
        if tpx1(i,1)==tpx2(j,1)
            next_state=tpx1(i,1);
        end;
    end;
end;

else if vetor_Estados(x,1)<150 && vetor_Estados(x,2)==150
        while u==4
        u=randi(5,1,1);
         end;
    
        novo_Estado_x=vetor_Estados(x,1)+vetor_Acoes(u,1);
novo_Estado_y=vetor_Estados(x,2)+vetor_Acoes(u,2);
if novo_Estado_x>150||novo_Estado_x<25||novo_Estado_y<25||novo_Estado_y>150
    u=1;
    novo_Estado_x=vetor_Estados(x,1)+vetor_Acoes(u,1);
    novo_Estado_y=vetor_Estados(x,2)+vetor_Acoes(u,1);
end;
[tempx1 tempy1]=find(vetor_Estados==novo_Estado_x);
[tempx2 tempy2]=find(vetor_Estados==novo_Estado_y);
parx1y1=[tempx1 tempy1];
parx2y2=[tempx2 tempy2];
for ui=1:length(parx1y1)
     if parx1y1(ui,2)==1
           tpx1(ui,1)=parx1y1(ui,1);
           tpy1(ui,2)=parx1y1(ui,2);
     end;
end;
uy=1;
for ui=1:length(parx2y2)
     if parx2y2(ui,2)==2
           tpx2(uy,1)=parx2y2(ui,1);
           tpy2(uy,2)=parx2y2(ui,2);
           uy=uy+1;
     end;
end;
for i=1:length(tpx1)
    for j=1:length(tpx2)
        if tpx1(i,1)==tpx2(j,1)
            next_state=tpx1(i,1);
        end;
    end;
end;

        end;
    end;
    end;
    end;
    end;
    end;
    end;
    end;
end;
    
            
            contadordecobertura=0;
%recompensa é o numero de usuarios alocados.
for i=1:length(users1)
    distancia=sqrt(abs(users1(i,1)-vetor_Estados(x,1))^2+abs(users1(i,1)-vetor_Estados(x,2))^2);
     pr = Pt -(32.4+10*2.7989*log10(distancia)+20*log10(f));
       if pr>=-70
        %intercobertura(i,3)=1;    
        contadordecobertura=contadordecobertura+1;
       end;
end;
r=contadordecobertura; 
vetor_r(k)=r;
vetor_est(k)=x;

     
%  figure(2)
%      plot(k,r,'pb');
%      hold on
     
%   if (x <= 4 && x>=1)
%     next_state = x + u;
% else
%     next_state = x;
% end
% if (x == 4 && u == 1)
%     r = 5;
% elseif (x == 1 && u == -1)
%     r = 1;
% else
%     r = 0;
% end
    end

