# Create docker image

Run the build command, specifying the tag
```
docker build -t inno-radar:<tag> .
```

The image is now ready to be run.
```
docker run --rm -p 8080:80 inno-radar:<tag>
```
