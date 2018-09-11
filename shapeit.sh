#!bash

#Step1
for i in $(seq 1 22)
do
awk -v chr="$i" '$1==chr' /rd1/user/shenq/WGS.raw.illu/100SNP/GATK_filter_2.5/custom_filtered_snps.PASS.SNV.vcf > tmp
cat header tmp > custom_filtered_snps.PASS.SNV.chr"$i".vcf
done

awk '$1=="X"' /rd1/user/shenq/WGS.raw.illu/100SNP/GATK_filter_2.5/custom_filtered_snps.PASS.SNV.vcf >tmp
cat header tmp > custom_filtered_snps.PASS.SNV.chrX.vcf

mv custom_filtered_snps.PASS.SNV.chr*  SNP_chr/

#Step2
/rd1/user/shenq/bin/shapeit_v2_r837_GLIBCv2_12_static/bin/shapeit --thread 2 --input-vcf SNP_chr/custom_filtered_snps.PASS.SNV.chr1.vcf -O Haplotype.chr1 --in
put-map genetic_map_b37/genetic_map_chr1_combined_b37.txt -L log/shapeitChr1.log >log/chr1.log 2>log/chr1.err

cat SNP_chr/list.noChrXnoChr1 |while read f;do chr=`echo $f|cut -d '.' -f 4`; /rd1/user/shenq/bin/shapeit_v2_r837_GLIBCv2_12_static/bin/shapeit
 --thread 5 --input-vcf SNP_chr/$f -O Haplotype/Haplotype."$chr" --input-map genetic_map_b37/genetic_map_"$chr"_combined_b37.txt -L log/shapeit"$chr".log >log
/"$chr".log 2>log/"$chr".err;d one

/rd1/user/shenq/bin/shapeit_v2_r837_GLIBCv2_12_static/bin/shapeit --thread 5 --input-vcf custom_filtered_snps.PASS.SNV.chrX.vcf -O Haplotype.chrX -X --input-s
ex sex.list -L log/shapeitChrX.log >log/chrX.log 2>log/chrX.err

#Step3
cat SNP_chr/list.all|while read f; do chr=`echo $f|cut -d '.' -f 4`; /rd1/user/shenq/bin/shapeit_v2_r837_GLIBCv2_12_static/bin/shapeit -convert --thread 5 --i
nput-haps Haplotype/Haplotype."$chr" --output-vcf Haplotype/HaplotypeVcf."$chr" -L log/shapeitConvert.vcf."$chr".L.log >log/shapeitConvert.vcf."$chr".log 2>lo
g/shapeitConvert.vcf."$chr".err;done
