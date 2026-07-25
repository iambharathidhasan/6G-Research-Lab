clear
clc
close all

angles = [45 135 225 315];

figure

theta = linspace(0,2*pi,300);

plot(cos(theta),sin(theta),'k--')

hold on

for k=1:length(angles)

    I = cosd(angles(k));

    Q = sind(angles(k));

    plot([0 I],[0 Q],'LineWidth',2)

    plot(I,Q,'ro','MarkerFaceColor','r','MarkerSize',10)

end

grid on

axis equal

xlabel('I')

ylabel('Q')

title('QPSK Constellation from Rotating Vector')