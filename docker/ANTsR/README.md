# ANTsR docker

## Building

The default is to build master:HEAD, but you can specify a tag to build a
specific version using build args, like this:

```
docker build --build-arg antsr_version="v0.5.6.4" -t antsr .
```

## Running R or Rscript

To run R interactively:

```
docker run --rm -it antsr
```

To run Rscript:

```
docker run --rm  antsr Rscript -e 'print("Hello")'
```

## Controlling threads

The default number of threads is 1, override by passing the
`ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS` variable, eg 

```
docker run -e ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=2 ...
```

