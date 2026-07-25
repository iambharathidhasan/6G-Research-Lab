%% Module 4 : OFDM Transmitter using QPSK

clear;
clc;
close all;

%% Parameters

N = 128;                     % Number of OFDM subcarriers

%% Generate Random Bits

bits = randi([0 1],2*N,1);  % 2 bits per QPSK symbol

%% QPSK Mapping (Gray Coding)

bitPairs = reshape(bits,2,[])';

symbols = zeros(N,1);

for k = 1:N

    b1 = bitPairs(k,1);
    b2 = bitPairs(k,2);

    if b1==0 && b2==0
        symbols(k)=1+1j;

    elseif b1==0 && b2==1
        symbols(k)=-1+1j;

    elseif b1==1 && b2==1
        symbols(k)=-1-1j;

    else
        symbols(k)=1-1j;
    end

end

%% Normalize

symbols = symbols/sqrt(2);

%% Frequency Domain Plot

figure;

subplot(2,1,1)

stem(abs(symbols),'filled')

grid on

xlabel('Subcarrier')

ylabel('|X(k)|')

title('Frequency Domain QPSK Symbols')

%% OFDM IFFT

ofdmSignal = ifft(symbols);

%% Time Domain Plot

subplot(2,1,2)

plot(imag(ofdmSignal),'LineWidth',2)

grid on

xlabel('Sample')

ylabel('Amplitude')

title('Time Domain OFDM Waveform')