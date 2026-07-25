%% Week 1 - OFDM-ISAC: Range-Doppler estimation from a random data payload
%
% Question: can an OFDM frame carrying RANDOM communication data also
%           recover a target's range and velocity?
%
% Method:   frequency-domain (resource-grid) simulation.
%           Each target applies a phase ramp across subcarriers (delay)
%           and across symbols (Doppler). The receiver divides out the
%           known transmitted symbols (reciprocal filtering), then
%           IFFT across subcarriers -> range, FFT across symbols -> Doppler.
%
% Assumption: target delay < cyclic prefix, so the CP is not simulated
%             explicitly. (Week 8 removes this assumption.)
%
% Base MATLAB only - no toolboxes required.

clear; close all; clc;

%% ---------------- Parameters ----------------
c      = 3e8;         % speed of light [m/s]
fc     = 28e9;        % carrier frequency [Hz]
lambda = c/fc;        % wavelength [m]

df     = 120e3;       % subcarrier spacing [Hz]  (5G NR numerology mu=3)
N      = 1024;        % number of subcarriers
M      = 256;         % number of OFDM symbols in the CPI

B      = N*df;                 % occupied bandwidth [Hz]
T      = 1/df;                 % useful symbol duration [s]
Tcp    = T/8;                  % cyclic prefix duration [s]
Tsym   = T + Tcp;              % total OFDM symbol duration [s]

SNRdB  = 20;          % per-resource-element SNR [dB]

%% ---------------- Theoretical limits ----------------
dR      = c/(2*B);              % range resolution [m]
Rmax    = c/(2*df);             % max unambiguous range [m]
Rcp     = c*Tcp/2;              % max range covered by the CP [m]
dv      = lambda/(2*M*Tsym);    % velocity resolution [m/s]
vmax    = lambda/(4*Tsym);      % max unambiguous velocity [m/s]

fprintf('--- Theoretical limits ---\n');
fprintf('Bandwidth              : %.2f MHz\n', B/1e6);
fprintf('CPI duration           : %.2f ms\n',  M*Tsym*1e3);
fprintf('Range resolution       : %.2f m\n',   dR);
fprintf('Max unambiguous range  : %.1f m\n',   Rmax);
fprintf('Max range within CP    : %.1f m   <-- hard limit here\n', Rcp);
fprintf('Velocity resolution    : %.2f m/s\n', dv);
fprintf('Max unambiguous vel.   : %.1f m/s\n\n', vmax);

%% ---------------- Ground-truth targets ----------------
% [range (m), velocity (m/s, +ve = approaching), relative amplitude]
targets = [ 50,  20, 1.00;
           120, -35, 0.50];

%% ---------------- Transmit: random QPSK payload ----------------
% Unit-modulus symbols -> division at the RX is well conditioned.
% (Week 5 replaces this with 16QAM, where it is not.)
b1 = randi([0 1], N, M);
b2 = randi([0 1], N, M);
D  = ((1-2*b1) + 1j*(1-2*b2))/sqrt(2);

%% ---------------- Channel: apply each target ----------------
n = (0:N-1).';        % subcarrier index (column)
m = (0:M-1);          % symbol index (row)

Y = zeros(N, M);
for k = 1:size(targets,1)
    R  = targets(k,1);
    v  = targets(k,2);
    a  = targets(k,3);

    tau = 2*R/c;              % round-trip delay [s]
    fD  = 2*v/lambda;         % Doppler shift [Hz]

    rangePhase   = exp(-1j*2*pi*df*tau .* n);      % ramp across subcarriers
    dopplerPhase = exp( 1j*2*pi*Tsym*fD .* m);     % ramp across symbols

    Y = Y + a * D .* (rangePhase * dopplerPhase);
end

% Additive white Gaussian noise
sigma = 10^(-SNRdB/20);
Y = Y + sigma*(randn(N,M) + 1j*randn(N,M))/sqrt(2);

%% ---------------- Receive: reciprocal filtering + 2D FFT ----------------
Z = Y ./ D;                   % remove the data dependency

RD = fftshift( fft( ifft(Z, N, 1), M, 2 ), 2 );   % range (dim1), Doppler (dim2)

RDdB = 20*log10(abs(RD)/max(abs(RD(:))) + eps);

rangeAxis = (0:N-1) * c/(2*B);
velAxis   = (-M/2:M/2-1) * lambda/(2*M*Tsym);

%% ---------------- Estimate peaks ----------------
Pmap = abs(RD);
fprintf('--- Estimates ---\n');
for k = 1:size(targets,1)
    [~, idx]   = max(Pmap(:));
    [ri, vi]   = ind2sub(size(Pmap), idx);
    fprintf('Target %d : range %6.2f m (true %5.1f)  |  velocity %7.2f m/s (true %5.1f)\n', ...
            k, rangeAxis(ri), targets(k,1), velAxis(vi), targets(k,2));

    % blank a neighbourhood so the next-strongest peak is a different target
    rr = max(1,ri-6):min(N,ri+6);
    vv = max(1,vi-6):min(M,vi+6);
    Pmap(rr,vv) = 0;
end

%% ---------------- Figure 1: range-Doppler map ----------------
rIdx = rangeAxis <= 200;      % zoom to the region of interest

figure('Color','w','Position',[100 100 760 520]);
imagesc(velAxis, rangeAxis(rIdx), RDdB(rIdx,:));
set(gca,'YDir','normal'); axis xy;
caxis([-45 0]); colormap(parula); cb = colorbar;
cb.Label.String = 'Normalised magnitude [dB]';
xlabel('Velocity [m/s]'); ylabel('Range [m]');
title(sprintf('OFDM-ISAC range-Doppler map | B = %.1f MHz, %d symbols, SNR = %d dB', ...
      B/1e6, M, SNRdB));
hold on;
plot(targets(:,2), targets(:,1), 'ro', 'MarkerSize', 14, 'LineWidth', 1.6);
legend('Ground truth', 'TextColor','w', 'Location','northeast');
grid on;

%% ---------------- Figure 2: range cut through target 1 ----------------
[~, vBin] = min(abs(velAxis - targets(1,2)));

figure('Color','w','Position',[880 100 700 420]);
plot(rangeAxis(rIdx), RDdB(rIdx, vBin), 'LineWidth', 1.3);
hold on;
xline(targets(1,1), 'r--', 'LineWidth', 1.2);
xline(targets(2,1), 'k:',  'LineWidth', 1.2);
xlabel('Range [m]'); ylabel('Normalised magnitude [dB]');
title(sprintf('Range profile at v = %.1f m/s  (resolution = %.2f m)', velAxis(vBin), dR));
legend('Range profile','Target 1 (true)','Target 2 range','Location','northeast');
ylim([-50 2]); grid on;
