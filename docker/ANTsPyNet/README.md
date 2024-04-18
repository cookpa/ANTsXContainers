# ANTsPyNet docker

Container for ANTsPyNet with an option to pre-install data and pre-trained networks.

## Default user

The docker user is `antspyuser`, and the home directory `/home/antspyuser` exists in the
container. The container always has the ANTsPy data, so that you can call `ants.get_data`.

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
With the default user, attempts to download data will fail because the directory
`/home/antspyuser` is not writeable. This is by design, to prevent users unknowingly
downloading large amounts of data by running a container repeatedly, or by running many
containers in parallel.

To include all available data in a container build, use
`--build-arg install_antsxnet_data=1` when building the container, or pull from the
`latest-with-data` tag on Dockerhub.

Alternatively, users may mount directories on the local file systems to use as cache
locations.

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


### Ensuring cache validity ###

Running multiple versions of ANTsPyNet with the same cache directory can lead to
conflicts. ANTsPyNet fetches data based on unique identifiers encoded in the source, so it
will never fetch the wrong data even if newer data exists. However, the cached file names
on disk are shared across versions, so for example if
`~/.keras/ANTsXNet/brainExtractionRobustT1.h5` has been downloaded already, it will not be
updated even if ANTsPyNet is updated. Similarly, if a a new version of that file is
downloaded, it will be used by by older ANTsPyNet installations that use the same cache
directory.