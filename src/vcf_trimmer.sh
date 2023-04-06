#!/bin/bash
# vcf_trimmer 0.0.1
# Andrew R Wood
# University of Exeter
# No warrenty provided!
# App will run on a single machine from beginning to end.

main() {

    set -e
    unset DX_WORKSPACE_ID
    dx cd $DX_PROJECT_CONTEXT_ID:

    # Return inputs from user or defaults where not provided
    echo "VCF list filename: '$vcf_file_list'"
    echo "Label to add to filename prior to .vcf.gz: '$file_label'"
    echo "Output directory: '$output_dir'"
    echo "Fields to remove: '$fields_to_remove'"
    echo "Thresholds for variant inclusion: '$qc_thresholds'"
    echo "Number of threads: '$threads'"
    echo "Number of VCFs to process concurrently: $concurrent_processes"

    # Download file with VCF list to worker
    dx download "$vcf_file_list" -o vcf_file_list

    # read files into array
    readarray -t arr < vcf_file_list

    # Process X VCFs at a time through xargs. This should account for number of threads per process
    printf '%s\0' "${arr[@]}" | xargs -0 -n1 -P$concurrent_processes sh -c 'bash process_vcf.sh "$1" $fields_to_remove $qc_thresholds $threads $file_label $output_dir' _

}

