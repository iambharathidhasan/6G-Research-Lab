%% Module 1 : Random Bit Generation

clear;
clc;
close all;

%% Parameters

numBits = 1024;          % Number of bits

%% Generate random bits

bits = randi([0 1],numBits,1);

%% Display

disp("First 20 Bits")

disp(bits(1:20))

%% Plot

figure;

stem(bits(1:40),'filled')

xlabel('Bit Index')

ylabel('Bit Value')

title('Random Binary Information')