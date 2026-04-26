filename = 'StepResponseUnControlled.mat';
S = load(filename);
data = S.StepResponseUnControlled.output;

t = data.time(:);
y = data.signal(:);

Ts = t(2) - t(1);
Fs = 1/Ts;

fc = 0.3;   % cutoff frequency in Hz (you will tune this)

[b,a] = butter(3, fc/(Fs/2));   % normalize by Nyquist frequency
y1 = filtfilt(b, a, y);             % zero-phase filtering

figure
plot(StepResponse.output.time,lowpass(StepResponse.output.signal,0.01),'DisplayName', 'uncontrolled output')
hold on
xlabel('time(s)')
ylabel('output')
plot(t, y1, 'g', 'DisplayName', 'controlled output')
xlim(0, 30);
%plot(t,lowpass(y,0.01), 'DisplayName','controlled output')
legend
title('Step Response of Controlled System')

grid on