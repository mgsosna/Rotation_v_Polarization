# Rotation_v_Polarization
This code will calculate global rotation and global polarization for a group of animals, given their x-, y-coordinates and orientations. Global polarization describes the alignment within the group. Global rotation describes movement around the center of the group's mass. Equations for global rotation and polarization come from Tunstrøm et al. 2013 (PLoS Computational Biology, http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1002915) and are given below:

Group polarization: 1/N * abs( sum[i -> N] ( u[i] ) ) 

Group rotation: 1/N * abs ( sum[i -> N] ( u[i] * r[i] ) )

u[i] is an individual's unit vector orientation, consisting of the x- and y-components. The components can range from -1 (left/down) to +1 (right/up). 

r[i] is the unit vector from the group centroid pointing towards individual i.

