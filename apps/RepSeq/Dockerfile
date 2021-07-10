FROM rocker/r-ver:4.0.0

ARG WHEN

RUN apt-get update && \
  apt-get install -y libcurl4-openssl-dev libssl-dev libssh2-1-dev libxml2-dev zlib1g-dev && \
  R -e "options(repos = \
  list(CRAN = 'http://mran.revolutionanalytics.com/snapshot/${WHEN}')); \
  install.packages(c('devtools','argparse', 'testthat', 'roxygen2', 'BiocManager', 'data.table','pbapply','pheatmap','naturalsort', 'scales', 'magick','Rcpp', 'vegan', 'ggplot2'))"
RUN R -e "BiocManager:: install('DESeq2')"



COPY ./common/process_mixcr_to_tm.R /home/analysis/process_mixcr_to_r.R
COPY ./common/diversity.R /home/analysis/diversity.R
COPY ./common/cdr3length.R /home/analysis/cdr3length.R

