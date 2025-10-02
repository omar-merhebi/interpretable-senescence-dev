nextflow.enable.dsl=2

include { ADATA_TO_TABLES } from '../modules/preprocess/ingest.nf'

workflow PREPROCESS {
    take:
    adata_ch

    main:
    script_adata= Channel.fromPath("${params.reporoot}/src/preprocess/ingest_anndata.py")
    proc_out = ADATA_TO_TABLES(adata_ch, script_adata)

    emit: 
    proc_out.cells_raw_vals
    proc_out.cells_metadata
    proc_out.well_mapping
    proc_out.treatment_mapping
}