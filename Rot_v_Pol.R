# For every group size...
for(i in 1:length(group.folders)){
  setwd(paste0(src, group.folders[i]))
  
  trials <- list.dirs(".")[2:4]     # Get the names of the trials
  
  # For every trial...
  for(j in 1:length(trials)){
    setwd(paste0(src, group.folders[i]))
    setwd(trials[j])
    
    files <- list.files(pattern = ".h5")
    
    # For every chunk...
    for(k in 1:length(files)){
      
      # Load the positions and headings
      xs <- h5read(files[k], "xs_(cm)")
      ys <- h5read(files[k],"ys_(cm)")
      
      BO.x <- h5read(files[k], "BO.x")
      BO.y <- h5read(files[k], "BO.y")
      
      
      ################################################################################
      # 1. Polarization
      # - Definition: how aligned is the group? 0 = no alignment (everyone facing diff 
      #   directions), 1 = perfectly aligned (everyone facing the same direction)
      # ------------------------------------------------------------------------------
      # 1a. Calculate the absolute value of the mean individual heading
      
      # Step 1: Get mean heading in x direction, mean in y direction
      # - You want to take all the left components, all the right components, let them accumulate
      #   and cancel each other out, and find the remainder
      head.x <- colMeans(BO.x, na.rm = T)
      head.x[head.x == "NaN"] <- NA
      
      head.y <- colMeans(BO.y, na.rm = T)
      head.y[head.y == "NaN"] <- NA
      
      # Step 2: find the magnitude of the resulting vector. 
      # - This magnitude will be between zero and 1. Zero = all the individuals' headings canceled 
      #   each other out. 
      
      pol <- sqrt(head.x^2 + head.y^2)
      
      ################################################################################
      # 2. Rotation
      # - Definition: the group's degree of rotation around its center of mass. 
      #   0 = no rotation, 1 = rotation
      #--------------------------------------------------------------------------------
      # 2a. Find the centroid of the group
      
      centX <- colMeans(xs, na.rm = T)
      centX[centX == "NaN"] <- NA
      
      centY <- colMeans(ys, na.rm = T)
      centY[centY == "NaN"] <- NA
      
      #--------------------------------------------------------------------------------
      # Distance to centroid
      # - Position relative to centroid. Negative = to the left/down, positive = above/right
      dis.x <- sweep(xs, 2, centX, "-")
      dis.y <- sweep(ys, 2, centY, "-")
      
      tot.dist <- sqrt(dis.x^2 + dis.y^2)
      
      #--------------------------------------------------------------------------------
      # Relative unit vector from centroid towards each fish
      rel.u.x <- rel.u.y <- matrix(NA, nrow = nrow(xs), ncol = ncol(xs))
      rel.u.x <- dis.x / tot.dist
      rel.u.y <- dis.y / tot.dist
      
      #--------------------------------------------------------------------------------------
      # Group rotation
      rot <- BO.x*rel.u.y - BO.y*rel.u.x
      full.rotation <- colMeans(rot, na.rm = T)
      full.rotation <- abs(full.rotation)
      
      # Add to the matrices
      # - i = 1, 2, 3 refers to whether we're in the 10-, 30-, or 70-fish folders
      if(i == 1){   
        rotation_10fish[j, k, 1:length(full.rotation)] <- full.rotation
        polarization_10fish[j, k, 1:length(pol)] <- pol
        
      } else if (i == 2){
        rotation_30fish[j, k, 1:length(full.rotation)] <- full.rotation
        polarization_30fish[j, k, 1:length(pol)] <- pol
        
      } else if (i == 3){
        rotation_70fish[j, k, 1:length(full.rotation)] <- full.rotation
        polarization_70fish[j, k, 1:length(pol)] <- pol
        
      }
      
      print(paste("Group size:", group.folders[i], "-", "Trial", j, "-", "Chunk", k))
    } # Close k loop (chunks)
    
  }  # Close j loop (trials)
  
} # Close i loop (group sizes)