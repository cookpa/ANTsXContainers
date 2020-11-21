# ANTsPy docker


## Controlling threads

The default number of threads is 1, override by passing the
`ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS` variable, eg

```
docker run -e ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=2 ...
```


## Version and dependency information

Run the container with `-m pip freeze` to get version information. 
