# ANTsPy docker

ANTsPy docker images are available from

https://hub.docker.com/repository/docker/antsx/antspy/general

A Dockerfile is included with ANTsPy for users building from source

https://github.com/ANTsX/ANTsPy


## Controlling threads

The Dockerfile in ANTsPy does not set a maximum number of threads. If required, set
`ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS` at run time

```
docker run -e ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=8 ...
```


## Version and dependency information

Run the container with `-m pip freeze` to get version information.
