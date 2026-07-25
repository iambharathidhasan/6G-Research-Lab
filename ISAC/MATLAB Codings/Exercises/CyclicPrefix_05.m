%% Module 5 : Cyclic Prefix in OFDM

clear
clc
close all

%% Parameters

N = 64;          % OFDM size
CP = 32;         % Cyclic Prefix Length

%% Generate Random QPSK Symbols

bits = randi([0 1],2*N,1);

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

symbols = symbols/sqrt(2);

%% OFDM Signal

ofdm = ifft(symbols);

%% Add Cyclic Prefix

cp = ofdm(end-CP+1:end);

txSignal = [cp ; ofdm];

%% Plot

figure

subplot(2,1,1)

plot(real(ofdm),'LineWidth',2)

grid on

title('Original OFDM Symbol')

xlabel('Sample')

subplot(2,1,2)

plot(real(txSignal),'LineWidth',2)

grid on

title('OFDM Symbol with Cyclic Prefix')

xlabel('Sample')