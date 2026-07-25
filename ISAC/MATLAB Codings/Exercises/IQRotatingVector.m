%% Experiment 2 : Rotating I/Q Vector

clear
clc
close all

theta = linspace(0,2*pi,300);

I = cos(theta);
Q = sin(theta);

figure

for k = 1:length(theta)

    clf

    % Unit circle
    plot(I,Q,'k--')
    hold on

    % Rotating vector
    plot([0 I(k)],[0 Q(k)],'r','LineWidth',3)

    % Current point
    plot(I(k),Q(k),'bo','MarkerSize',10,'MarkerFaceColor','b')

    grid on

    axis equal

    xlim([-1.2 1.2])

    ylim([-1.2 1.2])

    xlabel('I')

    ylabel('Q')

    title('Rotating I/Q Vector')

    drawnow

end

