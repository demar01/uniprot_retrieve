library(biomaRt)
library(GenomicRanges)
library(BSgenome.Hsapiens.UCSC.hg19)

mart=useMart("ensembl",dataset="hsapiens_gene_ensembl")

#get activity
activity=getBM(attributes=c('hgnc_symbol','go_id','name_1006','uniprot_swissprot'), mart=ensembl)

## HMT(methyltransferases) or 
HMT=activity[grep("histone methyltransferase",activity$name_1006),];HMT=HMT[order(HMT$hgnc_symbol),]
HDAT=activity[grep("histone methyltransferase",activity$name_1006),]; HMT=HMT[order(HMT$hgnc_symbol),]

##keep this as .txt to search againts uniprot
###this is done becuase GO information of histone transferase is not complete
write.table(as.data.frame(unique(activity[grep("histone methyltransferase",activity$name_1006),]$uniprot_swissprot)), file="histone_methyltransferase.txt")


system("
awk '{print $1="http://www.uniprot.org/uniprot""/"$2".txt"}' histone_methyltransferase.txt 

sed 's/"//g' histone_methyltransferase.txt >> histone_methyltransferase.txt

mv histone_methyltransferase.txt list_of_methyltransferases.txt


while read -r url; do
    wget -O foo $url
done < list_of_methyltransferases.txt

#mkdir folder_of_methyltransferases and search in this folder

for i in $(ls);do
grep "H3K" $i
done
")


