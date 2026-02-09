#!/usr/bin/env python3
import pandas as pd
import sys
import os

def fix_picrust2_ko_format(input_file, output_file=None, column_idx=1):
    """
    Fix PICRUSt2 output format by removing 'KO:' prefix from KO identifiers
    in the first column.
    
    Parameters:
    -----------
    input_file : str
        Path to input file (tsv or tsv.gz)
    output_file : str
        Path to output file (optional). If None, will overwrite input.
    column_idx : numeric,
        The column_idx to remove "KO:", for _contrib.tsv.gz, Use column_idx = 1; for _unstrat.tsv.gz, use column_idx = 0
    """
    # If output not specified, overwrite input
    if output_file is None:
        output_file = input_file
    
    # Check if file is gzipped
    if input_file.endswith('.gz'):
        compression = 'gzip'
    else:
        compression = None
    
    # Read the file
    print(f"Reading file: {input_file}")
    df = pd.read_csv(input_file, sep='\t', compression=compression)
    
    # Check the first column name
    first_col = df.columns[0]
    print(f"First column name: {first_col}")
    
    # Remove 'KO:' prefix from the first column values
    if df.iloc[:, column_idx].astype(str).str.startswith('ko:').any():
        print("Removing 'KO:' prefix from first column values...")
        df.iloc[:, column_idx] = df.iloc[:, column_idx].astype(str).str.replace('^ko:', '', regex=True)
    
    
    # Write the fixed file
    print(f"Writing fixed file: {output_file}")
    df.to_csv(output_file, sep='\t', index=False, compression=compression)
    
    return df

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python fix_picrust2_output.py <input_file> [output_file] [column_ind]")
        print("If output_file is not provided, input_file will be overwritten.")
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else None
    column_idx = sys.argv[3] if len(sys.argv) > 3 else 1 # by default, set column_idx = 1

    fix_picrust2_ko_format(input_file, output_file, column_idx)