%% Module 3 : 16QAM Modulation
clear;
clc;
close all;

%% Generate Random Bits

numBits = 400;      % Must be multiple of 4

bits = randi([0 1],numBits,1);

%% Ensure multiple of 4

if mod(length(bits),4)~=0
    bits=[bits; zeros(4-mod(length(bits),4),1)];
end

%% Group into 4-bit symbols

bitGroups = reshape(bits,4,[])';

%% Initialize

symbols = zeros(size(bitGroups,1),1);

%% Gray-coded 16QAM Mapping

levels = [-3 -1 1 3];

for k = 1:size(bitGroups,1)

    b = bitGroups(k,:);

    % I bits
    Iindex = bi2de(b(1:2),'left-msb');

    % Q bits
    Qindex = bi2de(b(3:4),'left-msb');

    % Gray coding
    gray = [1 2 4 3];

    I = levels(gray(Iindex+1));

    Q = levels(gray(Qindex+1));

    symbols(k) = I + 1j*Q;

end

%% Normalize Average Power

symbols = symbols/sqrt(10);

%% Plot Constellation

figure

plot(real(symbols),imag(symbols),'bo','MarkerFaceColor','b')

grid on

xlabel('In-phase')

ylabel('Quadrature')

title('16QAM Constellation')

axis([-2 2 -2 2])

axis square