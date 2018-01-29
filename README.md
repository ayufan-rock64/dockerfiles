## Dockerfiles for build environments

This repository has prebuilt docker images with build environments for all images in this repository. Ensure that you have [binfmt_misc enabled](https://github.com/ayufan-rock64/linux-build/blob/master/recipes/binfmt-misc.md).

```bash
docker run ... ayufan/rock64-dockerfiles:x86_64
```

or

```bash
docker run ... ayufan/rock64-dockerfiles:arm64
```

## Author

Kamil Trzciński, 2018
