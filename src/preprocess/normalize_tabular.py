import argparse
import os
import pandas as pd

from pathlib import Path
from sklearn.preprocessing import StandardScaler, MinMaxScaler


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--csv",
                        required=True,
                        help="Raw csv values.")

    parser.add_argument("--outdir",
                        required=True,
                        help="The output directory.")

    parser.add_argument("--znorm",
                        required=False,
                        action="store_true",
                        help="Whether or not"
                        "to Z-normalize dataset (True/False).")

    parser.add_argument("--minmax",
                        required=False,
                        action="store_true",
                        help="Whether or not"
                        "to Min-Max-normalize dataset (True/False).")

    args = parser.parse_args()

    csv = Path(args.csv)
    outdir = Path(args.outdir)

    os.makedirs(outdir, exist_ok=True)

    raw_vals = pd.read_csv(csv, index_col=0)

    if args.znorm:
        znorm = pd.DataFrame(
            StandardScaler().fit_transform(raw_vals),
            index=raw_vals.index,
            columns=raw_vals.columns)

        znorm_out = outdir / "cells_znorm.csv"
        znorm.to_csv(znorm_out, index=True)

    if args.minmax:
        minmaxnorm = pd.DataFrame(
            MinMaxScaler().fit_transform(raw_vals),
            index=raw_vals.index,
            columns=raw_vals.columns)

        minmax_out = outdir / "cells_minmaxnorm.csv"
        minmaxnorm.to_csv(minmax_out, index=True)


if __name__ == '__main__':
    main()
