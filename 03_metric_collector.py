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

def process(output_dir, files, report_basename):
    subprocess.run(
        ["Rscript", "-e", "rmarkdown::render('04_metric_collector.Rmd', \
                  param=list(input_files='%s', \
                  out_html = '%s'))" %(files,  op.join(output_dir, report_basename)) ],
        cwd = output_dir,
    )
    
def main():
    parser = argparse.ArgumentParser(description='Run method on files.')

    parser.add_argument('--output_dir', type=str, help='Output directory.')
    parser.add_argument('--report_basename', type=str, help='HTML report basename.')
    parser.add_argument('--metrics.scores', type=str, nargs='+', help='Metrics files.')
    
    args, _ = parser.parse_known_args()

    files = getattr(args, 'metrics.mapping')
    output_dir = getattr(args, 'output_dir')
    report_bn = getattr(args, 'report_basename')
    
    process(output_dir, files, report_bn)


if __name__ == "__main__":
    main()
