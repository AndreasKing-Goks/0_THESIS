function [Fr] = Restoring_ROV_Force(xg, yg, zg, phi, theta)
global Param
Fr = [(Param.W - Param.B)*sin(theta);
      -(Param.W - Param.B)*cos(theta)*sin(phi);
      -(Param.W - Param.B)*cos(theta)*cos(phi);
      -(yg*Param.W - yb*Param.B)*cos(theta)*cos(phi) + (zg*Param.W - zb*Param.B)*cos(theta)*sin(phi);
       (zg*Param.W - zb*Param.B)*sin(theta) + (xg*Param.W - xb*Param.B)*cos(theta)*cos(phi);
      -(xg*Param.W - xb*Param.B)*cos(theta)*sin(phi) - (yg*Param.W - yb*Param.B)*sin(theta)];
end