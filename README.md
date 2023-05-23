## About
Specification mining is fundamental to verifying area-specific code invariants with runtime verification. However, the computational overhead increases monstrously for non-trivially sized repositories (> 100 MB). Similar problems are found in runtime monitoring, for which evolutionary-aware tools have been developed in an attempt to ameliorate complexity. However, in the context of specification mining, current evolution-aware analysis just compounds complex- ity further, due to the need for re-mining specifications at each evolution in a repository’s lifespan. We propose the first model for an incremental specification mining pipeline (ISM). By making use of ISM, specification miners can reap the benefits from an evolu- tionary aware system while getting rid of unnecessary overhead. We also present alternative ideas for integrating ISM into existing specification mining framework

## Build
The Dockerfile can used to build locally. This docker image takes a rather long time to build. A pre-built image is
available [here](https://hub.docker.com/repository/docker/cyankaet/specminer/general).

You can run
```bash
docker pull cyankaet/specminer
docker run -it -v shared:/usr/src/app/run-spec-miners/ws cyankaet/specminer
```
to create an interactive session. This will plop you into the main folder to run
`javert.sh`, `bddminer.sh`, and `dsm-manual.sh` at will.
