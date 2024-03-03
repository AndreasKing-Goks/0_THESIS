# MIR_THESIS
Simultaneous Hydrodynamic Parameters and Buoyancy Configuration Estimation of Underwater Vehicles for More Efficient Underwater Operation

• People often do not track the actual dynamical parameters of underwater
vehicles. Those dynamical parameters are added mass, drag coefficient,
and buoyancy configuration.
• Hydrodynamic parameters are difficult to measure. It often involves a
high-computational process such as BEM/CFD. Empirical approaches
might work but it lacks accuracy.
• When not considered, inaccurate dynamical parameters will lead to an
error in the equation of motion.
• Error from the equation of motion will deviate the movement of the under-
water vehicle away from the intended trajectory. This deviation however
can be corrected by the controller.
• Every time correction happens, additional thrusts will be used. Too much
of this will lead to more energy usage, making the underwater operation
less energy efficient.
• Another problem with the buoyancy state of the underwater vehicle, is
that ideally, the underwater vehicle has to be neutrally buoyant.
• In the case of a neutrally buoyant state is unattainable, a slightly positively
buoyant state is preferable. This will ensure that the underwater vehicle
will not sink in case of system failures. This will also ensure the underwater
vehicle does not output any downwards thrust jet when operating near the
seabed, as this jet burst can disturb the seafloor and create a cloud of sand
that might impact visibility.
• The complex shape of the underwater vehicle can be an obstacle in com-
puting the overall buoyancy configuration of the underwater vehicle that
yields a positively buoyant state.
• Setting up the buoyancy configuration manually at first can take a long
time, just for adjusting and testing the buoyancy configurations.
• A quick and practical estimation of hydrodynamic parameters and buoy-
ancy configuration is needed to increase the time efficiency of the mission
involving the deployment of underwater vehicles.
