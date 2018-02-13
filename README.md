# Docker image for Greenplum Database

## Building the image

Download dependencies.

```
sh ./download.sh
```

Build the image.

```
docker build -t gpdb .
```

## Starting a container using the image

```
docker run -ti gpdb
```

EOF

