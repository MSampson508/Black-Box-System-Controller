%gets data field of the .mat files
function data = loadFile(filename)
    S = load(filename);
    data = S.(filename);
end

%calculates frequency of ith .mat file based on the logspace(-4,4,50) spacing
function freq = getFrequency(i)
    freq = 10.^((8/49).*(i-1) - 4);
end


%get max amplitude after 350 data points for steady state
function maxAmp = getAmplitude(outSignal)
    ssBuffer = floor(length(outSignal)/3);
    maxAmp = (max(outSignal(ssBuffer:end)) - min(outSignal(ssBuffer:end)))/2;
end

%start_ and end_ specify how many files you want (probably 1,50)
function amplitudes = getAllAmplitudes(start_, end_)
    amplitudes = zeros(1, 50); %array of all 0's
    for i = start_: end_
        file = sprintf('BlackBoxFrequencyResponse%d', i);
        data = loadFile(file);
        filtered_signal = lowpass(data.output.signal,0.001);
        amplitudes(i) = getAmplitude(filtered_signal);
    end
end

function ps = getPhaseShift(input,output,frequency)

    %gets time of first rising 0 of the input/output signal after removing first
    %350 for steady state
    ssBuffer = floor(length(output.signal)/3);
    idxInput = ssBuffer + (find((input.signal(ssBuffer:end-1)<0)  &  (input.signal(ssBuffer +1 :end)>0) , 1, 'first'));
    timeInput = input.time(idxInput);

    idxOutput = idxInput + (find((output.signal(idxInput:end-1)<0)  &  (output.signal(idxInput+1:end)>0) , 1, 'first'));
    timeOutput = output.time(idxOutput);

    deltaT = -(timeOutput - timeInput); %time between rising 0's
    ps = 360*frequency*deltaT; 
    %ps = mod(phase + 180, 360) - 180; %normalizes to -180-180
end

%start_ and end_ specify how many files you want (probably 1,50)
function phaseShifts = getAllPhaseShifts(start_, end_)
    phaseShifts = zeros(1, 50); %array of all 0's
    for i = start_: end_
        file = sprintf('BlackBoxFrequencyResponse%d', i);
        data = loadFile(file);
        phaseShifts(i) = 360 + getPhaseShift(data.input, data.output, getFrequency(i));
        if i > 25
            if (phaseShifts(i) > 180 + phaseShifts(i-1)) 
                phaseShifts(i) = phaseShifts(i) - 360;
            end
        end
    end
end



%run to get all output amplitudes in the 50 files
amps = getAllAmplitudes(1,50);
%disp(amps)

%run to get all phase shifts from 1,50
phaseShifts = getAllPhaseShifts(1,50);
%disp(phaseShifts(1:46))

%get frequency data
freqs = zeros(1,50);      
for i = 1:50
    freqs(i) = getFrequency(i);
end

%run to plot Bode 

figure
semilogx(2*pi*freqs, 20*log10(amps))
grid on
xlabel('Frequency (rad/s)')
ylabel('Magnatude (dB)')

figure
semilogx(2*pi*freqs, phaseShifts)
grid on
xlabel('Frequency (rad/s)')
ylabel('Phase Shift (degrees)')
