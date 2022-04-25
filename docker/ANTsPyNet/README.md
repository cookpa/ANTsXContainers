# ANTsPyNet docker

This container is similar to the ANTsPy build, but additionally builds
ANTsPyNet.

We don't use ANTsPy as a base layer because of dependency conflicts. 


## Version and dependency information

Run the container with `-m pip freeze` to get version information.

Dependencies are installed first using `requirements.txt`.

The main Dockerfile will build a specific tagged release, while
latest.dockerfile will build the current HEAD revision of the ANTsPyNet master
branch.


## Run time data and pretrained networks

ANTsPyNet downloads data at run time. ANTsPyNet code distinguishes data (eg, a
template brain) from pretrained networks, but the issues around downloading and
storing them are the same, so we'll use "data" for both types here.

Functions that use ANTsXNet external data take a parameter
`antsxnet_cache_directory`, but this may be deprecated in the future.

By default, data is downloaded on demand and stored in a cache directory at
`${HOME}/.keras`. This needs to be handled differently in docker vs singularity.

To include data in a container build, use `--build-arg install_antsxnet_data=1`.


### In docker

In docker, the default is to run as the user `antspyuser`. Running with `-v
/my/cache/dir:/home/antspyuser/.keras` will create a persistent cache that the
container can use.

Optionally, the mount point source could be "${USER}/.keras", but this may
require synchronizing the user information at run time to avoid permissions
issues.


### In singularity

Singularity containers always run as the system user. By default, the user's
home directory will be mounted and ANTsXNet data will be cached in
`${HOME}/.keras`.

To use containers with built-in data, run with `--home /home/antspyuser`.


### Getting data for offline use

If you run the container without Internet access, you will need to download the
data separately and then mount it within the container.

The script `get_antspynet_data.py` can be used to download all the ANTsXNet data
and networks, which can be mounted at run time.

Alternatively, pull the cookpa/antspynet:version-with-data image, which has the
data pre-installed. Beware this makes the container much larger.
