nextflow.enable.dsl=2

process ADATA_TO_TABLES {
    cpus 2
    memory '4 GB'
    time '2h'

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
            "processed/base_tables/${fname}"
        } else if (fname in ['cells_metadata.csv','well_mapping.csv','treatment_mapping.csv']) {
            "metadata/${fname}"
        } else {
            null
        }
    }

    script:
    """
    echo "DEBUG: projectDir=${projectDir}"
    echo "DEBUG: launchDir=${launchDir}"
    echo "DEBUG: params.reporoot=${params.reporoot}"
    echo "DEBUG: params.logdir=${params.logdir}"
    echo "DEBUG: params.datadir=${params.datadir}"
    echo "DEBUG: params.outsidr=${params.outdir}"
    ls -la src || true
    pwd

    python ${ingest_script} \\
        --adata ${adata} \
        --metadir . \
        --outdir .

    echo '--- AFTER PY SCRIPT ---'
    pwd
    ls -lah || true
    find . -maxdepth 2 -type f -print || true
    """
}
