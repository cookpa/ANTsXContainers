FROM cookpa/antsr:0.5.7.4

COPY installANTsRNet.R /opt

RUN R_REMOTES_NO_ERRORS_FROM_WARNINGS=true Rscript /opt/installANTsRNet.R

ENV R_DEFAULT_PACKAGES="datasets,utils,grDevices,graphics,stats,methods,ANTsR,ANTsRNet"

CMD ["R"]
