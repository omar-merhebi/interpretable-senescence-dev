import anndata as ad
import argparse
import os
import pandas as pd

from pathlib import Path


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--adata",
                        required=True,
                        help="Anndata File for input.")

    parser.add_argument("--metadir",
                        required=True,
                        help="Output directory for treatment_well_mapping.")

    parser.add_argument("--outdir",
                        required=True,
                        help="Output directory for processed data.")

    args = parser.parse_args()

    outdir = Path(args.outdir)
    metadir = Path(args.metadir)

    os.makedirs(outdir, exist_ok=True)
    os.makedirs(metadir, exist_ok=True)

    data = ad.read_h5ad(Path(args.adata))
    data_meta = data.obs
    data_df = data.to_df()
    data_full = pd.concat([data_meta, data_df], axis=1)
    data_full.reset_index(drop=True, inplace=True)
    data_full.index.name = "cell_id"
    data_full.rename(columns={"sample_ID": "treatment_id"}, inplace=True)
    data_full = data_full.astype({"treatment_id": int})
    data_full.loc[data_full['treatment_id'] > 12,
                  'treatment_id'] = data_full["treatment_id"] - 1

    meta_outpath = metadir / 'cells_metadata.csv'

    cell_metadata = data_full[['well', 'treatment_id', 'treatment', 'label']]
    cell_metadata_idonly = cell_metadata.drop(columns=['treatment', 'label'])
    cell_metadata_idonly.to_csv(meta_outpath)

    meta_outpath = metadir / 'well_mapping.csv'

    well_mapping = data_full \
        .drop_duplicates(cell_metadata)[['well', 'treatment_id']] \
        .sort_values(by='treatment_id').reset_index(drop=True)
    well_mapping.to_csv(meta_outpath)

    meta_outpath = metadir / 'treatment_mapping.csv'

    treatment_mapping = data_full \
        .drop_duplicates(
            cell_metadata[['treatment_id',
                           'treatment']])[['treatment_id', 'treatment']]\
        .set_index('treatment_id').sort_index()

    treatment_mapping.to_csv(meta_outpath)

    outpath = outdir / 'cells_raw_vals.csv'

    data_full.drop(cell_metadata.columns, inplace=True, axis=1)
    data_full.to_csv(outpath)


if __name__ == '__main__':
    main()
