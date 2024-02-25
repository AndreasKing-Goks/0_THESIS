import numpy as np
from scipy.interpolate import splrep, splev
import matplotlib.pyplot as plt

# Sample set points (time, thrust)
set_points = [(0, 0), (2, 100), (4, 50), (6, 150), (8, 0)]

# Extract time and thrust from set points
time, thrust = zip(*set_points)

# Generate spline representation with different parameters
# Adjust the smoothness and stiffness parameters here
# k: Degree of the smoothing spline. Increase for a stiffer curve.
# s: Positive smoothing factor. Higher values make the curve smoother.
tck_smooth = splrep(time, thrust, k=3, s=0.9)  # Adjust k and s as needed

# Define time intervals for evaluation
time_intervals = np.linspace(0, 8, 100)  # Adjust 100 as needed for resolution

# Evaluate the spline at defined time intervals
thrust_output_smooth = splev(time_intervals, tck_smooth)

# Plot the curve
plt.figure()
plt.plot(time_intervals, thrust_output_smooth, label='Smoothed Thrust Output')
plt.scatter(time, thrust, color='red', label='Set Points')
plt.xlabel('Time')
plt.ylabel('Thrust Output (N)')
plt.title('Smoothed Thrust Output Curve over Time')
plt.legend()
plt.grid(True)
plt.show()
