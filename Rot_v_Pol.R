######################################################################################################
# Calculate the global rotation and polarization, and label the group state. Based on Couzin et al.
# 2002 (Journal of Theoretical Biology) and Tunstrom et al. 2013 (PLoS Computational Biology).
# Matt Grobis | Jan 2018
#
# Global rotation, polarization functions:
# - Inputs: matrices, where each row is an individual's time series for x- and y-coordinates and
#           the unit vectors of their orientation.
# - Outputs: vectors of group rotation or polarization  
#   
# Group state function:
# - Input: global rotation and polarization vectors
# - Output: vector of group labels
#
#--------------------------------------------------------------------------------
# calculate_polarization
# - Definition: how aligned is the group? 0 = no alignment (everyone facing diff 
#   directions), 1 = perfectly aligned (everyone facing the same direction)
#
# - Inputs: the x- and y-unit matrices of the individuals' orientations. 
#    o Rows = individuals
#    o Columns = time points
#
#-----------------------------------------------------------------------------------------
# calculate_rotation
# - Definition: the group's degree of rotation around its center of mass. 
#   0 = no rotation, 1 = everyone swimming in a big torus
#
# - Inputs: the x- and y-position matrices, and the x- and y-unit vectors of orientation.
#    o Rows = individuals
#    o Columns = time points
#
#-----------------------------------------------------------------------------------------
# identify_state
# - Definition: assign the group state
#    o Rotation < 0.35, Polarization < 0.35: swarm
#    o Rotation < 0.35, Polarization > 0.65: polarized
#    o Rotation > 0.65, Polarization < 0.35: milling
#    o All others: transition
#
######################################################################################################

  calculate_polarization <- function(BO.x, BO.y){   
      # Step 1: Get mean heading in x direction, mean in y direction
      # - You want to take all the negative (left/down) components, all the right (right/up)
      # components, let them accumulate and cancel each other out, and divide what remains by N
      head.x <- colMeans(BO.x, na.rm = T)
      head.x[head.x == "NaN"] <- NA

      head.y <- colMeans(BO.y, na.rm = T)
      head.y[head.y == "NaN"] <- NA

      # Step 2: find the magnitude of the resulting vector. 
      # - This magnitude will be between zero and 1. 0 = all the individuals' headings canceled 
      #   each other out. 1 = all the individuals' headings were in the same exact direction.

      return(sqrt(head.x^2 + head.y^2))

  }

  #################################################################################################
  
  calculate_rotation <- function(xs, ys, BO.X, BO.y){
      # 1. Calculate the centroid of the group
      centX <- colMeans(xs, na.rm = T)
      centX[centX == "NaN"] <- NA

      centY <- colMeans(ys, na.rm = T)
      centY[centY == "NaN"] <- NA

      #--------------------------------------------------------------------------------
      # 2. Find the distance to centroid
      dis.x <- sweep(xs, 2, centX, "-")  # Position relative to centroid in x domain
      dis.y <- sweep(ys, 2, centY, "-")  # Position relative to centroid in y domain

      tot.dist <- sqrt(dis.x^2 + dis.y^2)

      #--------------------------------------------------------------------------------
      # 3. Find relative unit vector from centroid towards each fish
      rel.u.x <- rel.u.y <- matrix(NA, nrow = nrow(xs), ncol = ncol(xs))
      rel.u.x <- dis.x / tot.dist
      rel.u.y <- dis.y / tot.dist

      #--------------------------------------------------------------------------------------
      # Group rotation
      rot <- BO.x*rel.u.y - BO.y*rel.u.x

      return(abs(colMeans(rot, na.rm = T)))

  }

  ######################################################################################################
  # Classify the group state based on the global rotation and polarization.
  # - Swarm: rotation < 0.35 & polarization < 0.35
  # - Milling: rotation > 0.65 & polarization < 0.35
  # - Polarized: rotation < 0.35 & polarization > 0.65
  # - Transition: all other combinations
  
  identify_state <- function(rot, pol){
    
    ifelse(rot < 0.35 & pol < 0.35, "Swarm", 
           
           ifelse(rot < 0.35 & pol > 0.65, "Polarized",
                  
                  ifelse(rot > 0.65 & pol < 0.35, "Milling", "Transition")))
  }
  
  
  # The arrangement here is a little strange, but we need to do something like this to be able to 
  # use ifelse. ifelse lets us perform if statements on all elements in a vector, as opposed to 
  # being limited to the first element (as is the case with "if").
 
  
