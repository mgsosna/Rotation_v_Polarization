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

function calculate_polarization(heading_x, heading_y)
	# Step 1: mean heading in x- and y-directions
	# 1 = columns (time points), 0 = individuals
	mean_HX = mapslices(mean, heading_x, 1)
	mean_HY = mapslices(mean, heading_y, 1)

	# Step 2: Return magnitude of resulting vector
	return sqrt.(mean_HX .^2 + mean_HY .^2)
end

#-------------------------------------------------------------
function calculate_rotation(x_pos, y_pos, heading_x, heading_y)
    # Step 1: calculate centroid of group
    mean_x = mapslices(mean, x_pos, 1)
    mean_y = mapslices(mean, y_pos, 1)

    # Step 2: find distance to centroid
    dis_x = x_pos .- mean_x
    dis_y = y_pos .- mean_y

    tot_dist = sqrt.(dis_x .^2 .+ dis_y .^2)

    # Step 3: find relative unit vector from centroid towards fish
    rel_u_x = dis_x ./ tot_dist
    rel_u_y = dis_y ./ tot_dist

    # Step 4: return group rotation
    rot = heading_x .* rel_u_y .- heading_y .* rel_u_x

    return abs.(mapslices(mean, rot, 1))
end

#-------------------------------------------------------------------
# Identify state
function identify_state(rot, pol)
	states = []

	for i in 1:length(rot)
		if rot[i] < 0.35 && pol[i] < 0.35
			push!(states, "Swarm")

		elseif rot[i] < 0.35 && pol[i] > 0.65
			push!(states, "Polarized")

		elseif rot[i] > 0.65 && pol[i] < 0.35
			push!(states, "Milling")

		else
			push!(states, "Transition")
		end
	end
	return states
end
