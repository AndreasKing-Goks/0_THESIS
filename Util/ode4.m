function [t, y] = ode4(odefun, tspan, y0)
    dt = tspan(2) - tspan(1);  % Assumes uniform spacing
    t = tspan(1):dt:tspan(end);
    y = zeros(length(t), length(y0));
    y(1,:) = y0;

    for i = 1:(length(t)-1)
        k1 = dt * odefun(t(i), y(i,:)).';
        k2 = dt * odefun(t(i) + dt/2, y(i,:) + k1.'/2).';
        k3 = dt * odefun(t(i) + dt/2, y(i,:) + k2.'/2).';
        k4 = dt * odefun(t(i) + dt, y(i,:) + k3.').';
        y(i+1,:) = y(i,:) + (k1.' + 2*k2.' + 2*k3.' + k4.') / 6;
    end
end
