%% Module 2 : QPSK Modulation
clear;
clc;
close all;

%% Generate Random Bits

numBits = 100;

bits = randi([0 1],numBits,1);

%% Make sure number of bits is even

if mod(length(bits),2)~=0

    bits=[bits;0];

end

%% Group bits into pairs

bitPairs = reshape(bits,2,[])';

%% Initialize symbols

symbols = zeros(size(bitPairs,1),1);

%% Gray Mapping

for k=1:size(bitPairs,1)

    b1 = bitPairs(k,1);
    b2 = bitPairs(k,2);

    if b1==0 && b2==0
        symbols(k)=1+1j;

    elseif b1==0 && b2==1
        symbols(k)=-1+1j;

    elseif b1==1 && b2==1
        symbols(k)=-1-1j;

    elseif b1==1 && b2==0
        symbols(k)=1-1j;

    end

end

%% Normalize Power

symbols = symbols/sqrt(2);

%% Plot Constellation

figure;

plot(real(symbols),imag(symbols),'bo','MarkerFaceColor','b')

grid on

xlabel('In-phase')

ylabel('Quadrature')

title('QPSK Constellation')

axis([-2 2 -2 2])

axis square