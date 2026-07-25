%% Week 1 - Module 4
% OFDM Waveform Generation

clear;
clc;
close all;

%% Parameters
N = 64;     % Number of subcarriers

%% Generate Random Bits
bits = randi([0 1],2*N,1);

%% Manual Gray-coded QPSK Mapping
bitPairs = reshape(bits,2,[])';
symbols = zeros(N,1);

for k=1:N

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

symbols = symbols/sqrt(2);

%% OFDM Generation
ofdmSignal = ifft(symbols);

%% Plot

figure;

subplot(2,2,1)
plot(real(symbols),imag(symbols),'bo','MarkerFaceColor','b')
grid on
axis equal
title('QPSK Constellation')
xlabel('I')
ylabel('Q')

subplot(2,2,2)
stem(abs(symbols),'filled')
grid on
title('Frequency Domain Symbols')
xlabel('Subcarrier')
ylabel('|X(k)|')

subplot(2,2,3)
plot(real(ofdmSignal),'LineWidth',1.5)
grid on
title('Real Part of OFDM Signal')
xlabel('Sample')

subplot(2,2,4)
plot(abs(ofdmSignal),'LineWidth',1.5)
grid on
title('Magnitude of OFDM Signal')
xlabel('Sample')