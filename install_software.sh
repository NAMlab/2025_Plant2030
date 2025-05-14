# Setting up conda
conda info

conda create --name rnaseq
conda activate rnaseq
 
# Installing software using conda

conda install -c bioconda fastqc
conda install -c bioconda multiqc
conda install -c bioconda kallisto
