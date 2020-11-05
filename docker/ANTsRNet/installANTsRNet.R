# This is needed if not using a base image with devtools
install.packages("devtools", repos = "https://mirrors.nics.utk.edu/cran", dependencies = T)

library(devtools)

# turning off upgrades allows us to build from an ANTsR base image
# without upgrading ANTsR
install_github( "ANTsX/ANTsRNet", upgrade = "never" )

# Installs tensorflow and python bindings 
library(keras) 
install_keras(method = c("virtualenv"), version = "default", tensorflow = "default", extra_packages = c("tensorflow-hub"))
