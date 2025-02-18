#!/usr/bin/env python

"""
Ingests metrics from https://github.com/omnibenchmark/clustering_example

Calls Rscript - to do rmarkdown reporting.

Izaskun Mallona
18 Feb 2025
"""

import argparse
import os.path as op
import subprocess
import sys

def process(output_dir, metrics_metafile, report_basename):
    """
    So rmarkdown::render is called pointing to a Rmd script placed within (sys.path[0]) this very script dir
    Caution the rmarkdown output directory specification is confusing: '.' propagates the 'out/{name}' path
    """
    subprocess.run(
        ["Rscript", "-e", "rmarkdown::render('%s', \
                  param=list(input_files_mapping='%s', \
                             outputs_directory='%s'), \
                  output_file = '%s', \
                  output_dir = '%s')" %(op.join(sys.path[0], '04_metric_collector.Rmd'),
                                         op.abspath(metrics_metafile),
                                         op.abspath(op.join(output_dir, '..')),
                                         report_basename,
                                         op.abspath(output_dir)) ],
        cwd = output_dir,
    )
    
def main():
    parser = argparse.ArgumentParser(description='Run method on files.')

    parser.add_argument('--output_dir', type=str, help='Output directory.')
    parser.add_argument('--metrics.scores', type=str, nargs='+', help='Metrics files.')
    
    args, _ = parser.parse_known_args()

    files = getattr(args, 'metrics.scores')
    output_dir = getattr(args, 'output_dir')

    files = [op.abspath(x) for x in files]
    with open(op.join(output_dir, 'inputs.txt'), 'w') as fh:
        fh.write("\n".join(map(str, files)))

    print(output_dir)
    process(output_dir = output_dir,
            metrics_metafile = op.join(output_dir, 'inputs.txt'),
            report_basename = 'plotting_report.html')


if __name__ == "__main__":
    main()
