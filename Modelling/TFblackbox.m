zeroArray = [-461.3901,2.9924,0.0999];
poles = [-2598.6,-842.1,-20.3,-0.008];
k = 2862.2;
sys = zpk(zeroArray,poles,k);

% sys0 = zpk(zeroArray, poles, k);
% t = StepResponse.output.time;
% y = StepResponse.output.signal;
% u = StepResponse.input.signal;  
% Ts = t(2) - t(1);
% data = iddata(y(1:100000), u, Ts);
% sys = tfest(data,4,3);


figure
bode(sys)

t = StepResponse.output.time(1:100000);  
[y_step, t_step] = step(sys, t);
y1=lowpass(StepResponse.output.signal(1:100000),(0.001/1));

%y1 = StepResponse.output.signal;
figure
plot(t,y1,"Black",'DisplayName', 'actual system')
hold on
plot(t_step,y_step,"blue", 'DisplayName','model',LineWidth=1.5)
ylim([-0.15 0.8])
xlim([0 100])
title('Step Response of System vs Model')
xlabel('time(s)')
ylabel('output power (Watts)')
legend
%disp(rmse(y_step, y1))
disp('hello')

% goated setups:

%tfest produced this one
% zeroArray = [-461.3901,2.9924,0.0999];
% poles = [-2598.6,-842.1,-20.3,-0.008]; %making the last pole -0.009 makes
% step better but not Bode
% k = 2862.2;

%Chat came up with this one, its better RMSE but angles differently
% zeroArray = [0.75, 3.75, -25];
% poles     = [-0.005, -11.25, -397.27, -999.92];
% k         = 450.0;

% zeroArray = [1,5,-20];
% poles = [-0.01,-15,-500,-800];
% k = 600.79;

% zeroArray = [-1,-5,-20];
% poles = [-0.01,-15,-500,-800];
% k = 700.79;


% zeroArray = [-1,2,30];
% poles = [-0.1,-15,-500,-800];
% k = 2752.79;

% zeroArray = [1,10,100];
% poles = [-0.1,-30,-500,-1000];
% k = 2752.79;

% zeroArray = [1,10,100];
% poles = [-0.1,-50,-500,-1000];
% k = 2752.79;

