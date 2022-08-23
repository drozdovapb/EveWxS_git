## mitoRNA + mitoFinder

## software links
## bowtie2 with apt
## mitoRNA here: https://github.com/mozoo/mitoRNA (didn't really use the code but used the idea + parameters0
## MitoFinder here: https://github.com/RemiAllio/MitoFinder

## the final pipeline: bowtie2 to filter & then MitoFidner
## intermediate checks:
## - tried to assemble with MitoFinder from complete transcriptome samples, and it didn't work well
## compared megahit & metaspades, and metaspades seemed at least not worse and in some situations better
## update: in the end combined: most from metaspades + if didn't work well looked with metafinder

## also tried just assembling with SPAdes from the filtered reads
##	[*] spades -o EveBK_B24_plasmid --plasmid --threads 16 -1 EveB24.1.fq -2 EveB24.2.fq  ##plasmid
##  [*] spades -o EveBK_B24_rna --rna --threads 16 -1 EveB24.1.fq -2 EveB24.2.fq  ##RNAseq
##	[*] spades -o EveBK_B24_single_cell --sc --threads 16 -1 EveB24.1.fq -2 EveB24.2.fq  ##single cell
##	[*] spades -o EveBK_B24_single_cell --meta --threads 16 -1 EveB24.1.fq -2 EveB24.2.fq  ##meta
## it works, and it looks (haven't checked properly) like meta works the best (assembles about 17 kb in 8 contigs). 
## So, I can just second the MitoFinder's opinion:
## -- metaspades (recommended: a bit slower but more efficient

####### cat bowtie_and_mitofinder.sh
		## run bowtie2 to filter the reads
		bowtie2 -x $ref.ind --al-conc $samplename.fq -p 8 --very-sensitive-local -N 1 -L 10 -1 $fq1 -2 $fq2 -S sam
		## now to MitoFinder: assemble & annotate with megahit & metaspades
		cd MitoFinder
		export fq1=../$samplename.1.fq
		export fq2=../$samplename.2.fq
		/media/secondary/apps/MitoFinder/mitofinder -j ${samplename}_filt_megahit -1 $fq1 -2 $fq2 -r ../KF690638_Eve_mt_complete_genome.gb -o 5 -p 8 -m 10
		/media/secondary/apps/MitoFinder/mitofinder -j ${samplename}_filt_metaspades -1 $fq1 -2 $fq2 -r ../KF690638_Eve_mt_complete_genome.gb -o 5 -p 8 -m 10  --metaspades
#######



export ref=KF690638_Eve_mt_complete_genome.fasta
## a very important thing to remember about this reference:
## 16S rRNA = rrnL is probably reverse complement relative to what it should be
## TODO check it with MITOS (?)
bowtie2-build $ref $ref.ind

## four new samples
export samplename=EveUB_2018_1   ## submitted to SRA as SRR21152012
export fq1=/media/tertiary/transcriptome_raw/Labeglo_NEBNext_RNAseq_Polina/EveUB_2018_1/EveUB_2018_1_NEB_Index-4_S4_R1_001.fastq.gz
export fq2=/media/tertiary/transcriptome_raw/Labeglo_NEBNext_RNAseq_Polina/EveUB_2018_1/EveUB_2018_1_NEB_Index-4_S4_R2_001.fastq.gz
./bowtie_and_mitofinder.sh

export samplename=EveUB_2018_7   ## submitted to SRA as SRR21152011
export fq1=/media/tertiary/transcriptome_raw/Labeglo_NEBNext_RNAseq_Polina/EveUB_2018_7/EveUB_2018_7_NEB_Index-19_S19_R1_001.fastq.gz
export fq2=/media/tertiary/transcriptome_raw/Labeglo_NEBNext_RNAseq_Polina/EveUB_2018_7/EveUB_2018_7_NEB_Index-19_S19_R2_001.fastq.gz
./bowtie_and_mitofinder.sh

export samplename=EvePB_2   ## submitted to SRA as SRR21152013
export fq1=/media/tertiary/transcriptome_raw/Labeglo_NEBNext_RNAseq_Polina/EvePB-2/EvePB-2_NEB_Index-16_S1_R1_001.fastq.gz
export fq2=/media/tertiary/transcriptome_raw/Labeglo_NEBNext_RNAseq_Polina/EvePB-2/EvePB-2_NEB_Index-16_S1_R2_001.fastq.gz
./bowtie_and_mitofinder.sh

export samplename=EvePB_4    ## submitted to SRA as SRR21152014
export fq1=/media/tertiary/transcriptome_raw/Labeglo_NEBNext_RNAseq_Polina/EvePB-4/EvePB-4_NEB_Index-8_S3_R1_001.fastq.gz
export fq2=/media/tertiary/transcriptome_raw/Labeglo_NEBNext_RNAseq_Polina/EvePB-4/EvePB-4_NEB_Index-8_S3_R2_001.fastq.gz
./bowtie_and_mitofinder.sh

## previously published samples
## from our samples chose two different controls judging by the max number of reads (to have fewer problems with broken gene sequences)
export samplename=EveBK_B3_1
export fq1=/media/tertiary/transcriptome_raw/Eulimnogammarus_verrucosus/EveB3_1/SRR8205970_1.fastq.gz
export fq2=/media/tertiary/transcriptome_raw/Eulimnogammarus_verrucosus/EveB3_1/SRR8205970_2.fastq.gz
./bowtie_and_mitofinder.sh

export samplename=EveBK_B12_1
export fq1=/media/tertiary/transcriptome_raw/Eulimnogammarus_verrucosus/EveB12_1/SRR8205863_1.fastq.gz
export fq2=/media/tertiary/transcriptome_raw/Eulimnogammarus_verrucosus/EveB12_1/SRR8205863_2.fastq.gz
./bowtie_and_mitofinder.sh

export samplename=EveBK_Naumenko
export fq1=/media/tertiary/RNAseq_reads_SRA/Eulimnogammarus_verrucosus/SRR3467068_1.fastq.gz
export fq2=/media/tertiary/RNAseq_reads_SRA/Eulimnogammarus_verrucosus/SRR3467068_2.fastq.gz
./bowtie_and_mitofinder.sh

export samplename=Evi_Naumenko
export fq1=/media/tertiary/RNAseq_reads_SRA/Eulimnogammarus_vittatus/SRR3467061_1.fastq.gz
export fq2=/media/tertiary/RNAseq_reads_SRA/Eulimnogammarus_vittatus/SRR3467061_2.fastq.gz
./bowtie_and_mitofinder.sh



