nextflow.enable.dsl=2

include { PREPROCESS } from './subworkflows/preprocess.nf'

workflow {
    params.outdir = params.outdir ?: 'results'
    assert params.adata : "Missing --adata"

    ch_adata = Channel.fromPath(params.adata)
    PREPROCESS(ch_adata)
}
