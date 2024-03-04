clear
clc
% ExSpline - Cubic Hermite and spline interpolation of waypoints
wpt.pos.x = [0 100 500 700 1000];
wpt.pos.y = [0 100 100 200 160];
wpt.time = [0 40 60 80 100];

t = 0:1:max(wpt.time);
x_p = pchip(wpt.time, wpt.pos.x,t);

y_p = pchip(wpt.time, wpt.pos.y,t);
x_s = spline(wpt.time, wpt.pos.x,t);
y_s = spline(wpt.time, wpt.pos.y,t);

subplot(311), plot(wpt.time,wpt.pos.x,'o',t,[x_p; x_s]);
subplot(312), plot(wpt.time,wpt.pos.y,'o',t,[y_p; y_s]);
subplot(313), plot(wpt.pos.y,wpt.pos.x,'o',y_p,x_p,y_s,x_s);