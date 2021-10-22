## Dockerfile Optimization

Your boss Susan complains that even though everything is working, builds and deploys are taking longer than expected. Would you mind taking a look at these Dockerfiles to see if you can optimize them?

### Problem 1
Download: [1.Dockerfile](1.Dockerfile)

### Problem 2
Download: [2.Dockerfile](2.Dockerfile)

### Problem 3
Download: [3.Dockerfile](3.Dockerfile)

### Problem 4
Download: [4.Dockerfile](4.Dockerfile)

### Problem 5
This container isn't just larger than it needs to be, but a /var/lib file raised a flag with our security scanner. Think you might be able to reduce the footprint *and* pass the security scan?

You will need to clone the git repository with this command on your development box:

```bash
git clone https://github.com/jruels/docker-go-hello-world.git 
```

Build and run the file to see if it worked:

```bash
cd docker-go-hello-world
docker build -t helloworld .
docker run helloworld
```

Upon inspecting the image size, you'll see that it is quite large!

```bash
$ docker images | grep -i helloworld
helloworld                                                                latest                   ffead7b5dd8d        6 minutes ago        244MB
```

See if you can use what you learned about multi-stage builds to make this image much smaller. Try to shoot for an image size < 10MB. It's possible!

### Extra

If you need some help with multi-stage builds, check out the official Docker multi-stage documentation [here](https://docs.docker.com/develop/develop-images/multistage-build/).

Finish early? Take a look at these Dockerfiles from a pro. Perhaps not perfectly optimized, but great examples: [https://github.com/jessfraz/dockerfiles](https://github.com/jessfraz/dockerfiles)
