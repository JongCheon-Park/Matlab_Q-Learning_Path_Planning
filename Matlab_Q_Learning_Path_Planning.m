clc
clear
global Map map_x map_y

%% Make a map.
%Start Point = 3 , End Point = 4 Obstacle = 1
Map = zeros(10);
Map(2,2) = 3;
Map(9,9) = 4;
Map(2,4) = 1;
Map(4,4) = 1;
Map(7,3) = 1;
Map(8,5) = 1;
Map(9,1) = 1;
Map(5,10) = 1;
Map(9,7) = 1;
Map(10,2) = 1;

%Behavior definition
% 1 = UP
% 2 = DOWN
% 3 = LEFT
% 4 = RIGHT
action_num = 4;
map_x = size(Map,1);
map_y = size(Map,2);
Q = zeros(map_x,map_y,action_num);

[start_x, start_y] = find(Map == 3)
[end_x, end_y] = find(Map == 4);
[ob_x, ob_y] = find(Map == 1);
my_state = [start_x, start_y];

gamma = 0.8;
hold on;
% scatter(end_x, end_y)
is_goal = false;
stop_flag = false
i = 1
figure(1)
xlim([0,5])
ylim([0,5])
scatter(ob_x, ob_y, 'x', 'r', 'Linewidth', 15);
scatter(end_x, end_y, 'd', 'g', 'Linewidth', 15);
grid on;
while stop_flag~= true
    run(i) = 1;
    my_state = [start_x, start_y];
    is_goal = false;
    reward_all = 0;
   	clf
    xlim([0,10])
    ylim([0,10])
    scatter(ob_x, ob_y, 'x', 'r', 'Linewidth', 15);
    hold on;
    scatter(end_x, end_y, 'd', 'g', 'Linewidth', 15);
    hold on;
    grid on;
    tic
        
    while is_goal ~= true
        if rand(1) < (0.2 / i)
            select_action = ceil(rand(1)*4);
        else
            [trash_num action] = max(Q(my_state(1),my_state(2),:));
        end
        before_state = my_state;
        comet(my_state(1), my_state(2));
        [my_state reward] = env_step(my_state, action);
        run(i) = run(i) + 1;
        if my_state(1) == end_x & my_state(2) == end_y
            is_goal = true;
            reward = 10;
        end
        if i > 10
            if mean(run(i-10:i)) < 17
                stop_flag = true
                break;
            end
        end
        Q(before_state(1), before_state(2), action) = reward + gamma * max(Q(my_state(1), my_state(2), :));
    end
    i = i + 1;
end
figure(2)
plot(run)
             

%% Env definition
% The reward could be redesigned what you want.

function [env_out reward] = env_step(state,action)
    global Map map_x map_y
    if action == 1 % Up
        if state(1) == 1
            env_out = state;
            reward = -0.5;
        elseif Map((state(1)-1), state(2)) == 1
            env_out = state;
            reward = -0.5;
        else
            env_out = [state(1)-1 , state(2)];
            reward = -0.2;
        end
        
    elseif action == 2 % Down
        if state(1) == map_x
            env_out = state;
            reward = -0.5;
        elseif Map((state(1)+1), state(2)) == 1
            env_out = state;
            reward = -0.5;
        else
            env_out = [state(1)+1 , state(2)];
            reward = -0.2;
        end
        
    elseif action == 3 % Left
        
        if state(2) == 1
            env_out = state;
            reward = -0.5;
        elseif Map((state(1)), state(2)-1) == 1
            env_out = state;
            reward = -0.5;
        else
            env_out = [state(1) , state(2)-1];
            reward = -0.2;
        end 
        
    elseif action == 4 % Right
        if state(2) == map_y
            env_out = state;
            reward = -0.5;
        elseif Map((state(1)), state(2)+1) == 1
            env_out = state;
            reward = -0.5;
        else
            env_out = [state(1) , state(2)+1];
            reward = -0.2;
        end 
    end
end


 
 