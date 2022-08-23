## copied and pasted 
## some fasta the sequence of the each gene in UGENE; 
## also checked for wrong genes like these:
## 			WARNING: COX3 has been found more than once (2) in the different mitochondrial contigs.
##   		MitoFinder selected the longest sequence as the final sequence.
## in one case 
## aligned with mafft from inside UGENE
for file in *aln; do ~/lib/trimAl/source/trimal -in $file -out $file.fa -fasta; done

## now we need to concatenate + make a partition file
## to concatenate we need to make the names the sane (now they have gene name & tool)
## remove everything after @... 
## remove metaspades & megahit! (correct to MiFi?)
for file in *aln.fa; do sed -e 's/\@.*//' $file | sed -e 's/metaspades/mitofinder/' | sed -e 's/megahit/mitofinder/' >$file.upd; done
## make sure we don't have any other files (otherwise they'll get concatenated, and it's recursive :))
ls *upd | wc -l
#i'm done making the filenames even longer. Let's get rid of this.
mkdir renamed_alignments
for file in *upd
	do export base="$(basename -s .aln.fa.upd $file)"
	cp $file renamed_alignments/$base.aln
done
## now concatenate!
cd renamed_alignments
~/lib/catfasta2phyml.pl -c -f *aln > ../concat15genes11samples.aln.fa 2> ../concat15genes11samples.partitions
cd ../
## add to partitions
		cat add_to_partition.file 
		CODON5, 
		CODON5, 
		CODON5, 
		CODON5, 
		CODON5, 
		CODON5, 
		CODON5, 
		CODON5, 
		CODON5, 
		CODON5, 
		CODON5, 
		CODON5, 
		CODON5, 
		DNA, 
		DNA, 
paste add_to_partition.file concat15genes11samples.partitions -d "" >concat15genes11samples.partitions.txt


## now iqtree2 works fine!
## had to test the evolutionary model with the ones that work with BEAUTI
        ## also tried splitting all protein-coding genes into 3 partitions each
        ## like that:
        ## CODON5, ATP6_1 = 1-669\3
        ## CODON5, ATP6_2 = 2-669\3
        ## CODON5, ATP6_2 = 2-669\3
        ## CODON5, ATP8_1 = 670-825\3
        ## ...
        ## DNA, rrnL = 11014-11990
        ## DNA, rrnS = 11991-12593
        ## iqtree2 -s concat15genes11samples.aln.fa -m TEST+MERGE -p concat15genes11samples.partitions_3.txt -mset JC,HKY,TN93,GTR --prefix concat15genes11samples_beauti_mods -B 1000 -abayes
        ## it worked but ESS was extremely low, probably overparametrization?
        ## and the age was also weird
		#  ID  Name                                                                                       Type	Seq	Site	Unique	Infor	Invar	Const
		#   1  ATP6_1+ATP8_2+COX1_1+COX2_1+COX3_1+CYTB_1+ND1_1+ND2_1+ND3_1+ND4_1+ND4L_1+ND5_1+ND6_1+rrnS  DNA	11	4274	349	653	3252	3252
		#   2  ATP6_2+COX1_2+COX2_2+COX3_2+CYTB_2+ND2_2+ND3_2                                             DNA	11	2049	89	85	1884	1884
		#   3  ATP6_3+COX1_3+COX2_3+COX3_3+CYTB_3+ND2_3+ND3_3+ND6_3                                       DNA	11	2215	525	979	766	766
		#   4  ATP8_1+ATP8_3+ND6_2+rrnL                                                                   DNA	11	1247	182	208	929	929
		#   5  ND1_2+ND4_2+ND4L_2+ND5_2                                                                   DNA	11	1404	95	99	1249	1249
		#   6  ND1_3+ND4_3+ND4L_3+ND5_3                                                                   DNA	11	1404	436	692	432	432
		
## tried adding more gammaroid species
## alignments become much worse
## Gammarus fossarum isn't similar at all


iqtree2 -s concat15genes11samples.aln.fa -m TEST+MERGE -p concat15genes11samples.partitions_3.txt -mset JC,HKY,TN93,GTR --prefix concat15genes11samples_beauti_mods -B 1000 -abayes


#  ID  Name                                                                           Type	Seq	Site	Unique	Infor	Invar	Const
#   1  ATP6.aln+ATP8.aln+COX1.aln+COX2.aln+COX3.aln+CYTB.aln+ND2.aln+ND3.aln+ND6.aln  DNA	11	6796	650	1446	4585	4585
#   2  ND1.aln+ND4.aln+ND4L.aln+ND5.aln                                               DNA	11	4212	539	1027	2724	2724
#   3  rrnL.aln+rrnS.aln                                                              DNA	11	1583	209	244	1201	1201##

#  ID  Model                  LogL         AIC      w-AIC        AICc     w-AICc         BIC      w-BIC
#   1  GTR+F+G4         -23862.081   47744.163 + 8.27e-317   47744.195 + 4.94e-323   47812.404 +        0
#   2  GTR+F+G4         -15486.058   30992.115 + 8.27e-317   30992.168 + 4.94e-323   31055.572 +        0
#   3  HKY+F+G4          -4589.628    9191.256 + 8.27e-317    9191.310 + 4.94e-323    9223.459 +        0

## These models were used to set up BEAUTI
## short note: tried using the BEAUTI's internal model selector but ESS low.
