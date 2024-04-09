function [t, y, z] = ode4_thrust(odefun, tspan, y0, dt)
global Param
    t = tspan(1):dt:tspan(end);
    y = zeros(length(t), length(y0));
    z = zeros(length(t), 6);
    y(1,:) = y0';

    % STORE EACH FORCE
    Param.NIF_Fr = zeros(length(t), 6);
    Param.NIF_Fcrb = zeros(length(t), 6);
    Param.NIF_Fca = zeros(length(t), 6);
    Param.NIF_Fld = zeros(length(t), 6);
    Param.NIF_Fnld = zeros(length(t), 6);
    Param.NIF_Ft = zeros(length(t), 6);

    for i = 1:(length(t)-1)
        dydt = odefun(t(i), y(i,:)).';
        
        % Get force
        Param.NIF_Fr(i, :) = Param.NIF_Fr_o';
        Param.NIF_Fcrb(i, :) = Param.NIF_Crb_o';
        Param.NIF_Fca(i, :) = Param.NIF_Ca_o';
        Param.NIF_Fld(i, :) = Param.NIF_Fld_o';
        Param.NIF_Fnld(i, :) = Param.NIF_Fnld_o';
        Param.NIF_Ft(i, :) = Param.NIF_Ft_o';

        k1 = dt * dydt;
        z(i,:) = dydt(7:end);
        k2 = dt * odefun(t(i) + dt/2, y(i,:) + k1./2).';
        k3 = dt * odefun(t(i) + dt/2, y(i,:) + k2./2).';
        k4 = dt * odefun(t(i) + dt, y(i,:) + k3).';
        y(i+1,:) = y(i,:) + (k1 + 2*k2 + 2*k3 + k4) / 6;
    end
end
