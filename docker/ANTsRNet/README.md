# ANTsRNet docker

ANTsRNet is built using ANTsR as a base container, which speeds up the build
time substantially. See

https://github.com/ANTsX/ANTsR/tree/master/docker

for details of the base container.


## Building and version information

The latest ANTsRNet is built from Github, and dependencies are installed as
needed. Dependencies that are already installed in the base container (like
ANTsR) are not updated.


## Run time data

ANTsRNet downloads data at run time. If you run the container without Internet
access, you will need to download the data separately and then mount it within
the container at `~/.keras/ANTsXNet`.

See 

https://github.com/ANTsX/ANTsRNet/blob/master/R/getANTsXNetData.R

for details.
