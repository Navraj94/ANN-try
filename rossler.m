function y=rossler(t,y)
a=0.1;b=0.1;c=14;
y=[-y(2)-y(3);y(1)+a*y(2);b+y(3)*(y(1)-c)];