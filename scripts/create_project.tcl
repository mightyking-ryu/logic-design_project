# create_project.tcl

# -----------------------------------------------------------------------------
# OT_Final_Project - Create Project Script
# -----------------------------------------------------------------------------
# This script automates the creation of the Vivado project for the OT_Final_Project.
# It sets up project parameters, adds RTL and constraint files, configures the top module,
# and saves the project.
#
# Usage:
#   vivado -mode batch -source scripts/create_project.tcl
# -----------------------------------------------------------------------------

# Define the project name
set project_name "OT_Final_Project"

# Define the project directory (current working directory)
set project_dir [pwd]

# Define directories for RTL, constraints, and simulation files
set rtl_dir "$project_dir/src/rtl"
set constraints_dir "$project_dir/src/constraints"
set sim_dir "$project_dir/src/sim"

# Specify the FPGA part number
# Replace with your specific FPGA part if different
set part "xc7a35tcpg236-1"

# Create a new Vivado project without copying source files
create_project $project_name $project_dir -part $part

# Add all Verilog RTL source files from the rtl directory
add_files -norecurse [glob $rtl_dir/*.v]

# Add all constraint (.xdc) files from the constraints directory
add_files -fileset constrs_1 [glob $constraints_dir/*.xdc]

# Add all simulation (.v) files from the sim directory
add_files -fileset sim_1 [glob $sim_dir/*.v]

# Set the top module of the design
# Replace with your actual top module name if different
set_property top OT_top [current_fileset]

# Save the project to persist the changes
save_project

# Optional: Close Vivado after project creation
# Uncomment the following line if you want Vivado to exit after running the script
# exit
