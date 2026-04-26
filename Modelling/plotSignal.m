function data = loadFile(filename)
    S = load(filename);
    data = S.(filename);
end

%plots input and output signal on one plot
function plotData(data)
    T_in = data.input.time;
    T_out = data.output.time;
    ssBuffer = floor(length(data.output.signal)/3);

    %set butterworth filter

    ts = 0.0000005; %data.output.time(2) - data.output.time(1);
    fs = 1/ts;
    fc = 12000;
    [b,a] = butter(3, fc/(fs/2));   % normalized is 0.012
    y1 = filtfilt(b, a, data.output.signal);   


    figure
    hold on
    plot(T_in, data.input.signal)
    plot(T_out,lowpass(data.output.signal,0.001))
    %plot(T_out,y1,'g')
    %plot(T_out,data.output.signal)
    xline(T_in(ssBuffer),'r--', 'Steady State','LineWidth',2) 
    hold off
    
    legend('Input','Output')
    xlabel('Time')
    ylabel('Signal')
    grid on
end


% run to plot one file
data = loadFile('BlackBoxFrequencyResponse30');
plotData(data)
%disp(10.^((8/49).*(30-1) - 4))
