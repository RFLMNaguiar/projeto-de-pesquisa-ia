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
% learning parameters
gamma = 0.5;    % discount factor  % TODO : we need learning rate schedule
alpha = 0.5;    % learning rate    % TODO : we need exploration rate schedule
epsilon = 0.9;  % exploration probability (1-epsilon = exploit / epsilon = explore)
% states
state = [0,1,2,3,4,5];
action = [-1,1];
Q = zeros(length(state),length(action));
K = 1000;
state_idx = 3;  % the initial state to begin from
for k = 1:K
    disp(['iteration: ' num2str(k)]);
    r=rand;
    x=sum(r>=cumsum([0, 1-epsilon, epsilon]));
    

    if x == 1
        [~,umax]=max(Q(state_idx,:));
        current_action = action(umax);
    else
        current_action=datasample(action,1);
    end
    
    action_idx = find(action==current_action); % id of the chosen action
    [next_state,next_reward] = model(state(state_idx),action(action_idx),k);
    next_state_idx = find(state==next_state);  % id of the next state
    disp(['current state : ' num2str(state(state_idx)) ' next state : ' num2str(state(next_state_idx)) ' taken action : ' num2str(action(action_idx))]);
    disp([' next reward : ' num2str(next_reward)]);
    Q(state_idx,action_idx) = Q(state_idx,action_idx) + alpha * (next_reward + gamma* max(Q(next_state_idx,:)) - Q(state_idx,action_idx));
    if (next_state_idx == 6 || next_state_idx == 1)
        state_idx = datasample(2:length(state)-1,1); % we just restart the episode with a new state
    else
        state_idx = next_state_idx;
    end
    disp(Q);  % display Q in each level
end
% display the final Q matrix
disp('Final Q matrix : ');
disp(Q)
[C,I]=max(Q,[],2);
disp('Q(optimal):');
disp(C);
disp('Optimal Policy');
disp('*');
disp([action(I(2,1));action(I(3,1));action(I(4,1));action(I(5,1))]);
disp('*');
end
function [next_state,r] = model(x,u,k)
if (x <= 4 && x>=1)
    next_state = x + u;
else
    next_state = x;
end
if (x == 4 && u == 1)
    r = 5;
elseif (x == 1 && u == -1)
    r = 1;
else
    r = 0;
end
figure(1)
     plot(k,r,'pb');
     hold on
end