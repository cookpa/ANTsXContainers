# ANTsPyNet cortical thickness

Uses ANTsPyNet as a base layer for build efficiency. 

## Version and dependency information

Run the container with `-m pip freeze` to get version information.


## Cortical thickness example

Run the container with `-h` to see the usage for the script.

```
# Make a tmp dir locally to avoid storing tmp files in memory
mytemp=$(mktemp -d)

docker run \
  --rm \
  -it \
   -e TMPDIR=/tmp \
   -v ${mytemp}:/tmp:rw \
   -v /path/to/data:/data:ro \
   -v /path/to/output:/output:rw \
   antspynetct \
     -a /data/myt1w.nii.gz \
     -o /output/myt1w \
     -t 1 
```

The `-t` option controls the multi-threading of tensorflow operations. Beware
that multi-threading will use more memory. There are some calls to the ANTs
command line tools in the pipeline, threading here is controlled with the
environment variable `ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS`, which is set to 1,
unless overridden in the call to `docker run`.


## Runtime data

ANTsPyNet downloads data at run time, which can be problem for HPC users who are
firewalled from the Internet.

The data required to run a basic cortical thickness pipeline has already been
downloaded into the container. However, if you modify the script, the container
might need to access more data at run time.

If you run the container without Internet access and need additional data, you
will need to download the data separately, including the data within the
`ANTsXNet` folder here, and mount it within the container at
`~/.keras/ANTsXNet`.


See 

https://github.com/ANTsX/ANTsPyNet/blob/master/antspynet/utilities/get_antsxnet_data.py

for details.
