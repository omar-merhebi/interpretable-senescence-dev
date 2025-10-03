nextflow.enable.dsl=2

process NORMALIZE_TABULAR {
    cpus 1
    memory '4 GB'
    time '1h'

    input:
    path csv
    path norm_script
    val do_znorm
    val do_minmax

    output:
    path "cells_znorm.csv",         optional: true, emit: znorm
    path "cells_minmaxnorm.csv",    optional: true, emit: minmax

    publishDir "${params.outdir}", mode: 'link', saveAs: {fname ->
        "processed/tabular/${fname}"
    }

    script:
    // Build flags
    def znormFlag   = do_znorm  ? "--znorm"     : ""
    def minmaxFlag  = do_minmax ? "--minmax"    : ""

    """
    python ${norm_script} \
        --csv ${csv} \
        --outdir . \
        ${znormFlag} \
        ${minmaxFlag}
    """
}