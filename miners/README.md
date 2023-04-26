# Mining specifications from BDDMiner, Javert

## Preface

Please do **not** share any of the `jar` files that are in this directory with anyone else.

## Obtaining traces

To obtain traces for a project, run:

```
bash obtain-traces.sh ${PROJECT_FILE}
```
where PROJECT_FILE contains the url, sha, and name information for an open source project.
The produced trace file(s) will be placed under the `project-traces` directory.

ex)

```
bash obtain-traces.sh kamranzafar.jtar.txt
```

Note that the scripts for each of the spec miners will automatically run `obtain-traces.sh`, so there is no need to run the script by itself (this is just for reference).

## Running BDDMiner

BDDMiner mines specifications that match a given regular expression. In the script below, I have BDDMiner produce specifications for `(ab*c)*`, `(a+b*c+)?`, and `(a+b*c+)*`.

To run BDDMiner:
```
bash bddminer.sh ${PROJECT_FILE}
```
where PROJECT_FILE contains the url, sha, and name information for an open source project.
Results of mining will be written to ws/bdd-3/${PROJECT_NAME} where PROJECT_NAME is the name of the project.

## Running Javert

To run Javert:
```
bash javert.sh ${PROJECT_FILE}
```
where PROJECT_FILE contains the url, sha, and name information for an open source project.
Results of mining will be written to ws/javert/${PROJECT_NAME} where PROJECT_NAME is the name of the project.
