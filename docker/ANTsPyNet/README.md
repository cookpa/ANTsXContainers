# ANTsPyNet docker

This container is similar to the ANTsPy build, but additionally builds
ANTsPyNet.

We don't use ANTsPy as a base layer because of dependency conflicts. 


## Version and dependency information

Run the container with `-m pip freeze` to get version information.


## Run time data and pretrained networks

ANTsPyNet downloads data at run time. Functions that use external data take a
parameter `antsxnet_cache_directory`.

If you run the container without Internet access, you will need to download the
data separately and then mount it within the container. In Docker, it's easiest
to mount this to `/home/antspynetuser/.keras/ANTsXNet`, which is the default.

Singularity users without Internet access will need to mount data to
`$HOME/.keras/ANTsXNet` or use `antsxnet_cache_directory` to indicate another
location.

The script `get_antspynet_data.py` can be used to download all the ANTsXNet data
and networks.

See 

https://github.com/ANTsX/ANTsPyNet/blob/master/antspynet/utilities/get_antsxnet_data.py

for details.
