# Calculating global rotation and polarization
This R code will calculate global rotation and global polarization for a group of animals, given their x-, y-coordinates and orientations. Global polarization describes the alignment within the group. Global rotation describes movement around the center of the group's mass. Equations for global rotation and polarization come from [Couzin et al. 2002](http://www.sciencedirect.com/science/article/pii/S0022519302930651) (_Journal of Theoretical Biology_, ) with empirical validation in [Tunstrøm et al. 2013](http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1002915) (_PLoS Computational Biology_). The equations are given below:

### Group polarization: 
<a href="https://www.codecogs.com/eqnedit.php?latex=O_p&space;=&space;\frac{1}{N}\left&space;|&space;\sum_{i=1}^{N}\mathbf{u}_i&space;\right&space;|" target="_blank"><img src="https://latex.codecogs.com/gif.latex?O_p&space;=&space;\frac{1}{N}\left&space;|&space;\sum_{i=1}^{N}\mathbf{u}_i&space;\right&space;|" title="O_p = \frac{1}{N}\left | \sum_{i=1}^{N}\mathbf{u}_i \right |" /></a>

### Group rotation: 
<a href="https://www.codecogs.com/eqnedit.php?latex=O_r&space;=&space;\frac{1}{N}\left&space;|&space;\sum_{i=1}^{N}\mathbf{u}_i&space;\times&space;\mathbf{r}_i&space;\right&space;|" target="_blank"><img src="https://latex.codecogs.com/gif.latex?O_r&space;=&space;\frac{1}{N}\left&space;|&space;\sum_{i=1}^{N}\mathbf{u}_i&space;\times&space;\mathbf{r}_i&space;\right&space;|" title="O_r = \frac{1}{N}\left | \sum_{i=1}^{N}\mathbf{u}_i \times \mathbf{r}_i \right |" /></a>

<a href="https://www.codecogs.com/eqnedit.php?latex=\mathbf{u}_i" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\mathbf{u}_i" title="\mathbf{u}_i" /></a> is an individual's unit vector orientation, consisting of the x- and y-components. The components can range from -1 (left/down) to +1 (right/up). 

<a href="https://www.codecogs.com/eqnedit.php?latex=\mathbf{r}_i" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\mathbf{r}_i" title="\mathbf{r}_i" /></a> is the unit vector from the group centroid pointing towards individual i.

Group polarization and rotation each take on values between 0 and 1. Three distinct group "states" exist and are well-characterized by different combinations of global polarization and rotation:
- The **swarm** state (rotation < 0.35, polarization < 0.35) consists of disordered movement. 
- The **milling** state (rotation > 0.65, polarization < 0.35) consists of rotation around the group center, i.e. a torus configuration.
- The **polarized** state (rotation < 0.35, polarization > 0.65) consists of directed movement.
