clear
clc
close all

angles = [45 135 225 315];

figure

theta = linspace(0,2*pi,300);

plot(cos(theta),sin(theta),'k--')

hold on

grid on

axis equal

xlim([-1.2 1.2])

ylim([-1.2 1.2])

xlabel('I')

ylabel('Q')

title('Random QPSK Transmission')

for n=1:50

    k = randi(4);

    I = cosd(angles(k));

    Q = sind(angles(k));

    plot(I,Q,'ro','MarkerFaceColor','r','MarkerSize',10)

    pause(0.3)

end