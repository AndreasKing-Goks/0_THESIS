import rosbag
import numpy as np
from scipy.io import savemat
from std_msgs.msg import Float64, Float64MultiArray
from geometry_msgs.msg import Twist
import rospy
import os

# Specify the path to your ROS bag file
bag_file = '/media/goks/1234-5678/rosbags_new2/Day2/Case2/Freefloat2/ff_nb2.bag'

# Create arrays to store the data
override_data = []
rel_alt_data = []
roll_data = []
pitch_data = []

# Open the ROS bag
bag = rosbag.Bag(bag_file)

# Read messages from the bag
for topic, msg, t in bag.read_messages(topics=['/USV/mavros/rc/override', '/USV/mavros/global_position/rel_alt', '/USV/angle_radian', '/USV/tau_stb']):
    if topic == '/USV/mavros/rc/override':
        override_data.append([msg.channels[0], msg.channels[1], msg.channels[2], msg.channels[3], msg.channels[4], msg.channels[5]])
    elif topic == '/USV/mavros/global_position/rel_alt':
        rel_alt_data.append([msg.data])
    elif topic == '/USV/angle_radian':
        roll_data.append([msg.angular.x])
        pitch_data.append([msg.angular.y])

# Convert lists to numpy arrays
override_array = np.array(override_data)
rel_alt_array = np.array(rel_alt_data)
roll_array = np.array(roll_data)
pitch_array = np.array(pitch_data)

# Save arrays to .mat files
savemat('override.mat', {'override': override_array})
savemat('rel_alt.mat', {'rel_alt': rel_alt_array})
savemat('roll.mat', {'roll': roll_array})
savemat('pitch.mat', {'pitch': pitch_array})

# Close the bag
bag.close()

print("Data extraction and conversion completed successfully.")
