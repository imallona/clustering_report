#!/bin/bash


## with singularity

hyperfine 'ob run benchmark -b Clustering_singularity.yml --threads 15 --local' --runs 1 --export-csv singularity_1_hyperfine.txt

mv out out_singularity

Rscript -e "rmarkdown::render('00_clustering_metrics_overview.Rmd', \
                  param=list(input_dir = '/home/imallona/src/clustering_example/out_singularity', \
                  out_csv = 'out_singularity_metrics.csv'))"


## with envmodules

hyperfine 'ob run benchmark -b Clustering_envmodules.yml --threads 15 --local' --runs 1 --export-csv envmodules_1_hyperfine.txt

mv out out_envmodules

Rscript -e "rmarkdown::render('00_clustering_metrics_overview.Rmd', \
                  param=list(input_dir = '/home/imallona/src/clustering_example/out_envmodules', \
                  out_csv = 'out_envmodules_metrics.csv'))"


## with conda

hyperfine 'ob run benchmark -b Clustering_conda.yml --threads 15 --local' --runs 1 --export-csv conda_1_hyperfine.txt

mv out out_conda

Rscript -e "rmarkdown::render('00_clustering_metrics_overview.Rmd', \
                  param=list(input_dir = '/home/imallona/src/clustering_example/out_conda', \
                  out_csv = 'out_conda_metrics.csv'))"


diff --color out_singularity_metrics.csv out_envmodules_metrics.csv
diff --color out_conda_metrics.csv out_envmodules_metrics.csv
diff --color out_conda_metrics.csv out_singularity_metrics.csv


for fn in $( find out_conda -name "clustbench.scores.gz")
do
    # echo $fn
    agnostic=$(echo $fn | sed 's/out_conda//g')
    echo $agnostic
    echo 'conda'
    zcat out_conda/$agnostic
    echo 'singularity'
    zcat out_singularity/$agnostic
    echo 'envmodules'
    zcat out_envmodules/$agnostic
    echo 'diff3'
    diff3 -A  <(zcat out_conda/$agnostic) <(zcat out_singularity/$agnostic) <(zcat out_envmodules/$agnostic)
    echo
    echo
done
