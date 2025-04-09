# ANTsXContainers

Container building scripts for ANTsX tools.


## Container images

Download Docker images from
[Docker Hub](https://hub.docker.com/u/cookpa).


## Docker vs Singularity

To build a Singularity image, 

```
singularity build myAntsXImage.sif docker://cookpa/antsximage:tag
```

where "antsximage" is the Docker Hub repository you want to build from, and
"tag" is the version you want to build. You can instead user "latest" to get the
latest version.

Because it's relatively easy to build Singularity images from the Docker images,
this repository will focus primarily on Docker builds.

Please get in touch via the issues page if you are in need of Singularity
images - in other words, if you want to use the containers but can't build a
Singularity image yourself. If there is sufficient interest and time available,
we may be able to provide some Singularity recipes and images.


