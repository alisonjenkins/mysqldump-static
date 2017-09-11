# Mysqldump static binary

This docker container creates a mysqldump static binary (amongst others) and copies it to the output volume.

To use it run:

```
docker build -t mysqldump-static
docker run -it --rm -v `pwd`/output:/output mysqldump-static
```

You will then find the mysqldump static executable in an output directory.
