%% Experiment 1 : I and Q Signals

clear
clc
close all

%% Parameters

fs = 1000;          % Sampling frequency

f = 5;              % Signal frequency

t = 0:1/fs:1;

%% I Component

I = cos(2*pi*f*t);

%% Q Component

Q = sin(2*pi*f*t);

%% Plot

figure

subplot(2,1,1)

plot(t,I,'LineWidth',2)

grid on

title('I Component (Cosine)')

xlabel('Time')

ylabel('Amplitude')

subplot(2,1,2)

plot(t,Q,'LineWidth',2)

grid on

title('Q Component (Sine)')

xlabel('Time')

ylabel('Amplitude')

%% Complex Baseband Signal

s = I + 1j*Q;

figure

subplot(3,1,1)
plot(real(s),'LineWidth',2)
grid on
title('Real Part')

subplot(3,1,2)
plot(imag(s),'LineWidth',2)
grid on
title('Imaginary Part')

subplot(3,1,3)
plot(abs(s),'LineWidth',2)
grid on
title('Magnitude')

figure

plot(real(s),imag(s),'LineWidth',2)

grid on

axis equal

xlabel('I')

ylabel('Q')

title('I/Q Trajectory')