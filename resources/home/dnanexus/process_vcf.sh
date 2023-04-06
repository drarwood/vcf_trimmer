#!/bin/bash
# vcf_trimmer 0.0.1
# Andrew R Wood
# University of Exeter
# No warrenty provided!

# $1 = string containing full file path of VCF on DNANexus RAP
# $2 = string containing fields to remove from VCF
# $3 = string containing fields and threholds to apply for purposes of QC
# $4 = number of threads for compressed file writing by bcftools
# $5 = label to add to vcf processed
# $6 = output directory

# Check user has provided either fields to remove or metric thresholding
if [ "$2" != "NA" ] || [ "$3" != "NA" ]
then

    # 1. Get the file onto the worker
    echo "Processing $1"
    dx download "$1"

    # 2. Strip original path and define local input and output files
    IFS='/' read -r -a f <<< "$1"
    FILEIN=${f[-1]}
    FILEOUT="${FILEIN%.vcf.gz}_"$5".vcf.gz"

    # 3. Run bcftools accounting for options to include
    if [ "$2" != "NA" ] && [ "$3" != "NA" ]
    then
        bcftools annotate -x $2 $FILEIN | bcftools norm -m - | bcftools filter -i $3 -Oz -o $FILEOUT --threads $4
    elif [ "$2" != "NA" ] && [ "$3" == "NA" ]
    then
        bcftools annotate -x $2 $FILEIN | bcftools norm -m - -Oz -o $FILEOUT --threads $4
    else
        bcftools norm -m - $FILEIN | bcftools filter -i $3 -Oz -o $FILEOUT --threads $4
    fi

    # 4. Upload trimmed VCF here:
    dx upload $FILEOUT --path "$6/" --brief

    # 5. Clear the worker of input and output files to reserve storage
    rm $FILEIN $FILEOUT

else
    echo "Ignoring VCF as no filtering or removal of data fields requested!"
fi


