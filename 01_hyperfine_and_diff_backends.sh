#!/bin/bash


## with singularity

hyperfine 'ob run benchmark -b Clustering_singularity.yml --threads 5 --local' --runs 1 --export-csv singularity_1_hyperfine.txt

mv out out_singularity

Rscript -e "rmarkdown::render('00_clustering_metrics_overview.Rmd', \
                  param=list(input_dir = '/home/imallona/src/clustering_example/out_singularity', \
                  out_csv = 'out_singularity_metrics.csv'))"


## with envmodules

hyperfine 'ob run benchmark -b Clustering_envmodules.yml --threads 5 --local' --runs 1 --export-csv envmodules_1_hyperfine.txt

mv out out_envmodules

Rscript -e "rmarkdown::render('00_clustering_metrics_overview.Rmd', \
                  param=list(input_dir = '/home/imallona/src/clustering_example/out_envmodules', \
                  out_csv = 'out_envmodules_metrics.csv'))"


## with conda

hyperfine 'ob run benchmark -b Clustering_conda.yml --threads 5 --local' --runs 1 --export-csv conda_1_hyperfine.txt

mv out out_conda

Rscript -e "rmarkdown::render('00_clustering_metrics_overview.Rmd', \
                  param=list(input_dir = '/home/imallona/src/clustering_example/out_conda', \
                  out_csv = 'out_conda_metrics.csv'))"


diff out_singularity_metrics.csv out_envmodules_metrics.csv
diff out_conda_metrics.csv out_envmodules_metrics.csv
