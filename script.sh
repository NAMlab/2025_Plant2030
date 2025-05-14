# Here we get the data using a script from ENA Browser, checks the qualitiy of our fastq files and performs an alignment to the human cDNA transcriptome reference with Kallisto.
# This script checks the qualitiy of our fastq files and performs an alignment to the human cDNA transcriptome reference with Kallisto.
# To run this 'shell script' you will need to open your terminal and navigate to the directory where this script resides on your computer.
# This should be the same directory where you fastq files and reference fasta file are found.
# Change permissions on your computer so that you can run a shell script by typing: 'chmod +x script.sh' (without the quotes) at the terminal prompt 
# Then type './script.sh' (without the quotes) at the prompt.  
# This will begin the process of running each line of code in the shell script.

#Generate the directories
mkdir data
mkdir qc
mkdir genomes
mkdir mapped

# Get the data
wget -nc -P data ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR200/003/SRR2006793/SRR2006793.fastq.gz
wget -nc -P data ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR200/007/SRR2006797/SRR2006797.fastq.gz
wget -nc -P data ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR200/002/SRR2006792/SRR2006792.fastq.gz
wget -nc -P data ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR200/004/SRR2006794/SRR2006794.fastq.gz
wget -nc -P data ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR200/001/SRR2006791/SRR2006791.fastq.gz
wget -nc -P data ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR200/005/SRR2006795/SRR2006795.fastq.gz
wget -nc -P data ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR200/006/SRR2006796/SRR2006796.fastq.gz
wget -nc -P data ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR200/008/SRR2006798/SRR2006798.fastq.gz

# To direct the output to a specific subdirectory use: wget -nc -P output_subdirectory input_file 

# first use fastqc to check the quality of our fastq files:
fastqc data/*.gz -t 8 -o qc
# to make the output into a subdirectory 'qc' use: fastqc *.gz -t 4 -o qc

 
# next, we want to build an index from our reference fasta file 
# I get my reference mammalian transcriptome files from here: https://useast.ensembl.org/info/data/ftp/index.html
kallisto index -i genome/Solanum_lycopersicum.SL3.0.cdna.all.fa.index genome/Solanum_lycopersicum.SL3.0.cdna.all.fa.gz
 
# now map reads to the indexed reference host transcriptome
# use as many 'threads' as your machine will allow in order to speed up the read mapping process.
# note that we're also including the '&>' at the end of each line
# this takes the information that would've been printed to our terminal, and outputs this in a log file that is saved in /data/course_data
 
#PE - example for paired end, in case you have such data
#kallisto quant -i Homo_sapiens.GRCh38.cdna.all.index -o test -t 8 sample1_read1.fq.gz sample1_read2.fq.gz &> test.log
 
#SE single end
# first the healthy subjects (HS)
kallisto quant -i genome/Solanum_lycopersicum.SL3.0.cdna.all.fa.index -o mapped_reads/LMC -t 4 --single -l 50 -s 30 raw_reads/SRR2006793.fastq.gz
kallisto quant -i genome/Solanum_lycopersicum.SL3.0.cdna.all.fa.index -o mapped_reads/AMC -t 4 --single -l 50 -s 30 raw_reads/SRR2006797.fastq.gz
kallisto quant -i genome/Solanum_lycopersicum.SL3.0.cdna.all.fa.index -o mapped_reads/LWS -t 4 --single -l 50 -s 30 raw_reads/SRR2006792.fastq.gz
kallisto quant -i genome/Solanum_lycopersicum.SL3.0.cdna.all.fa.index -o mapped_reads/LMS -t 4 --single -l 50 -s 30 raw_reads/SRR2006794.fastq.gz
kallisto quant -i genome/Solanum_lycopersicum.SL3.0.cdna.all.fa.index -o mapped_reads/LWC -t 4 --single -l 50 -s 30 raw_reads/SRR2006791.fastq.gz
kallisto quant -i genome/Solanum_lycopersicum.SL3.0.cdna.all.fa.index -o mapped_reads/AWC -t 4 --single -l 50 -s 30 raw_reads/SRR2006795.fastq.gz
kallisto quant -i genome/Solanum_lycopersicum.SL3.0.cdna.all.fa.index -o mapped_reads/AWS -t 4 --single -l 50 -s 30 raw_reads/SRR2006796.fastq.gz
kallisto quant -i genome/Solanum_lycopersicum.SL3.0.cdna.all.fa.index -o mapped_reads/AMS -t 4 --single -l 20 -s 30 raw_reads/SRR2006798.fastq.gz
 

 
 
# summarize fastqc and kallisto mapping results in a single summary html using MultiQC
multiqc -d . 
 
echo "Finished"
