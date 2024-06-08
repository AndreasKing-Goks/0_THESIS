vols = [10,12,14,16,18,20];

vol_d = 14.8

vols_up = vols([vols>=vol_d])
vols_down = vols([vols<=vol_d])

vols_bracket = [vols_down(end) vols_up(1)]