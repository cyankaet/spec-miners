The Dockerfile can used to build locally. This docker image takes a rather long time to build. A pre-built image is
available [here](https://hub.docker.com/repository/docker/cyankaet/specminer/general).

You can run
```bash
docker pull cyankaet/specminer
docker run -it -v shared:/usr/src/app/run-spec-miners/ws cyankaet/specminer
```
to create an interactive session. This will plop you into the main folder to run
`javert.sh`, `bddminer.sh`, and `dsm-manual.sh` at will. Currently, `dsm-manual` will
not work due to its conda dependency.
