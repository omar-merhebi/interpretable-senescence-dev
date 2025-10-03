nextflow.enable.dsl=2

include { ADATA_TO_TABLES } from '../modules/preprocess/ingest.nf'
include { NORMALIZE_TABULAR } from '../modules/preprocess/normalize_tabular.nf'

workflow PREPROCESS {
    take:
    adata_ch

    main:
    // ingest
    script_adata    = Channel.fromPath("${params.reporoot}/src/preprocess/ingest_anndata.py")
    script_norm     = Channel.fromPath("${params.reporoot}/src/preprocess/normalize_tabular.py")
    
    ADATA_TO_TABLES(adata_ch, script_adata)

    raw_vals    = ADATA_TO_TABLES.out.cells_raw_vals
    metadata    = ADATA_TO_TABLES.out.cells_metadata
    well_map    = ADATA_TO_TABLES.out.well_mapping
    treat_map   = ADATA_TO_TABLES.out.treatment_mapping

    // norm
    def do_znorm    = params.norm?.znorm    ?: true
    def do_minmax   = params.norm?.minmax   ?: true

    norm = NORMALIZE_TABULAR(
        raw_vals,  // use csv from preproc
        script_norm,
        do_znorm,
        do_minmax
    )

    emit: 
    cells_raw_vals      = raw_vals
    cells_metadata      = metadata
    well_mapping        = well_map
    treatment_mapping   = treat_map

    cells_znorm         = norm.znorm
    cells_minmaxnorm    = norm.minmax
}