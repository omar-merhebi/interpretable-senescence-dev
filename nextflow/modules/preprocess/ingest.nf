nextflow.enable.dsl=2

process ADATA_TO_TABLES {
    cpus 1
    memory '4 GB'
    time '1h'

    input:
    path adata
    path ingest_script

    output:
    path "cells_raw_vals.csv",       emit: cells_raw_vals
    path "cells_metadata.csv",       emit: cells_metadata
    path "well_mapping.csv",         emit: well_mapping
    path "treatment_mapping.csv",    emit: treatment_mapping

    publishDir "${params.outdir}", mode: 'link', saveAs: { fname ->
        if (fname == 'cells_raw_vals.csv') {
            "processed/tabular/${fname}"
        } else if (fname in ['cells_metadata.csv','well_mapping.csv','treatment_mapping.csv']) {
            "metadata/${fname}"
        } else {
            null
        }
    }

    script:
    """
    python ${ingest_script} \\
        --adata ${adata} \
        --metadir . \
        --outdir .
    """
}
