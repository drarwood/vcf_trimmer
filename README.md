# VCF Trimmer for UK Biobank RAP
#### Developed by Andrew Wood. University of Exeter

This applet performs parallel processing of VCFs through [bcftools](https://samtools.github.io/bcftools/bcftools.html). This applet has been designed to reduce file sizes down when required for merging of data by:
* Removing fields within `INFO` and/or `FORMAT`
* Applies inclusion quality control thresholding based on field in `INFO`

---
### Obtaining and installing the applet
Clone this github repo to a local directory:
```
git clone https://github.com/drarwood/vcf_trimmer
```
Navigate to a relevant directory within the project directory on the DNAnexus platform
```
dx cd /path/to/install/apps
```
Now you are ready to build and upload the applet to the DNAnexus platform directory
```
dx build -f vcf_trimmer
```
---
### Inputs
This applet takes one file in as input that simply lists the VCFs to process, one per line. VCFs will be processed in the order as the appear in the file. For example:
```
/Bulk/Whole genome sequences/Population level WGS variants, pVCF format - interim 200k release/ukb24304_c1_b0_v1.vcf.gz
/Bulk/Whole genome sequences/Population level WGS variants, pVCF format - interim 200k release/ukb24304_c1_b1_v1.vcf.gz
/Bulk/Whole genome sequences/Population level WGS variants, pVCF format - interim 200k release/ukb24304_c1_b2_v1.vcf.gz
/Bulk/Whole genome sequences/Population level WGS variants, pVCF format - interim 200k release/ukb24304_c1_b3_v1.vcf.gz
/Bulk/Whole genome sequences/Population level WGS variants, pVCF format - interim 200k release/ukb24304_c1_b4_v1.vcf.gz
/Bulk/Whole genome sequences/Population level WGS variants, pVCF format - interim 200k release/ukb24304_c1_b5_v1.vcf.gz
/Bulk/Whole genome sequences/Population level WGS variants, pVCF format - interim 200k release/ukb24304_c1_b6_v1.vcf.gz
/Bulk/Whole genome sequences/Population level WGS variants, pVCF format - interim 200k release/ukb24304_c1_b7_v1.vcf.gz
/Bulk/Whole genome sequences/Population level WGS variants, pVCF format - interim 200k release/ukb24304_c1_b8_v1.vcf.gz
/Bulk/Whole genome sequences/Population level WGS variants, pVCF format - interim 200k release/ukb24304_c1_b9_v1.vcf.gz
```
---
### Command line usage

Strings that define inclusion criteria and fields to exclude should be consistent with input expected by bcftools and placed within quotes. See the [bcftools](https://samtools.github.io/bcftools/bcftools.html) manual for more information.

#### Example 1:
Removing all fields within `FORMAT` except for `GT` and applying inclusion critera of an `AAscore` >= 0.5:

```
dx run vcf_trimmer \
  -ivcf_file_list=/path/to/vcf_file_list.txt \
  -ifile_label=trimmed1 \
  -ioutput_dir=/path/to/output/dir \
  -iqc_thresholds="INFO/AAScore>=0.5" \
  -ifields_to_remove="FORMAT/FT,FORMAT/AD,FORMAT/MD,FORMAT/DP,FORMAT/RA,FORMAT/PP,FORMAT/GQ,FORMAT/PL" \
  -y
```

#### Example 2:
Removing all fields within `FORMAT` except for `GT` and `INFO` except for `AAscore` which must remain as as inclusion critera of an `AAscore` >= 0.5:

```
dx run vcf_trimmer \
  -ivcf_file_list=/path/to/vcf_file_list.txt \
  -ifile_label=trimmed2 \
  -ioutput_dir=/path/to/output/dir \
  -iqc_thresholds="INFO/AAScore>=0.5" \
  -ifields_to_remove="FORMAT/FT,FORMAT/AD,FORMAT/MD,FORMAT/DP,FORMAT/RA,FORMAT/PP,FORMAT/GQ,FORMAT/PL,INFO/ABHet,INFO/ABHom,INFO/ABHetMulti,INFO/ABHomMulti,INFO/AC,INFO/AF,INFO/AN,INFO/CR,INFO/CRal,INFO/CRalt,INFO/END,INFO/FEATURE,INFO/GT_ANTI_HAPLOTYPE,INFO/GT_HAPLOTYPE,INFO/GT_ID,INFO/HOMSEQ,INFO/INV3,INFO/INV5,INFO/LEFT_SVINSSEQ,INFO/LOGF,INFO/MaxAAS,INFO/MaxAASR,INFO/MaxAltPP,INFO/MMal,INFO/MMalt,INFO/MQ,INFO/MQalt,INFO/MQSal,INFO/MQsquared,INFO/NCLUSTERS,INFO/NGT,INFO/NHet,INFO/NHomRef,INFO/NHomAlt,INFO/NUM_MERGED_SVS,INFO/OLD_VARIANT_ID,INFO/ORSTART,INFO/OREND,INFO/QD,INFO/QDalt,INFO/PASS_AC,INFO/PASS_AN,INFO/PASS_ratio,INFO/RefLen,INFO/RELATED_SV_ID,INFO/RIGHT_SVINSSEQ,INFO/SB,INFO/SBAlt,INFO/SBF,INFO/SBF1,INFO/SBF2,INFO/SBR,INFO/SBR1,INFO/SBR2,INFO/SDal,INFO/SDalt,INFO/SEQ,INFO/SeqDepth,INFO/SV_ID,INFO/SVINSSEQ,INFO/SVLEN,INFO/SVMODEL,INFO/SVSIZE,INFO/SVTYPE,INFO/VarType" \
  -y
```

#### Example 3:
Removing all fields within `FORMAT` except for `GT` without applying inclusion critiera:
```
dx run vcf_trimmer \
  -ivcf_file_list=/path/to/vcf_file_list.txt \
  -ifile_label=trimmed3 \
  -ioutput_dir=/path/to/output/dir \
  -iqc_thresholds="NA" \
  -ifields_to_remove="FORMAT/FT,FORMAT/AD,FORMAT/MD,FORMAT/DP,FORMAT/RA,FORMAT/PP,FORMAT/GQ,FORMAT/PL" \
  -y
```

#### Example 4:
Applying inclusion critiera of `AAscore` >= 0.5 but do not remove any fields from VCF:
```
dx run vcf_trimmer \
  -ivcf_file_list=/path/to/vcf_file_list.txt \
  -ifile_label=trimmed4 \
  -ioutput_dir=/path/to/output/dir \
  -iqc_thresholds="INFO/AAScore>=0.5" \
  -ifields_to_remove="NA" \
  -y
```
#### Additional parameters
To assist in the throughput of this applet, multiple VCFs will be processed at the same time on a given workstation. The default instance type is `mem1_ssd1_v2_x36`. Benchmarking has been based on this server type and you should limit the maximum number of concurrent VCFs processed at a time to `20` to avoid resource issues.
```
-iconcurrent_processes (default: 20) : maximum number of VCFs to process at a given time.
-ithreads (default: 4) : number of threads bcftools should use when writing compressed output
```

You are strongly advised to run these jobs as high-priority to avoid automatic restarting of jobs on the RAP. See [`dx run`](https://documentation.dnanexus.com/user/helpstrings-of-sdk-command-line-utilities#run) on changing job priority etc.

