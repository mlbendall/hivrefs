#! /bin/bash

### Alignment Type #######################################################################
# The "filtered alignments" consist of a subset of sequences from the original web 
# alignments. Typically 80-95% of the sequences in the corresponding Web Alignment are 
# retained. The Filtered Alignments are cleaner, but contain less information. They are 
# only available for HIV-1
#
# ALL - All complete sequences
# COM - Compendium
# CON - Consensus/Ancestral
# FLT - Filtered Web
# REF - Subtype reference
# RIP - RIP custom background
alntype="FLT"
##########################################################################################

### Organism #############################################################################
# HIV1
# HIV2
# SIV
suborganism="HIV1"
##########################################################################################

### Subtype ##############################################################################
# All   - All
# ALLM  - All M group (A-K + recombinants)
# A-K   - M group without recombinants
genosub="ALLM"
##########################################################################################

### Year #################################################################################
year="2016"
##########################################################################################

destdir="${alntype}.${genosub}.${year}"

##########################################################################################
mkdir -p $destdir/DNA
mkdir -p $destdir/PRO
mkdir -p $destdir/GENOME

##########################################################################################


for region in "ENV" "GAG" "NEF" "POL" "REV" "TAT" "VIF" "VPR" "VPU"; do
    for basetype in "DNA" "PRO"; do
        echo "$alntype $year $genosub $region $basetype"
d="ORGANISM=HIV&\
SUBORGANISM=$suborganism&\
ALIGN_TYPE=$alntype&\
YEAR=$year&\
GENO_SUB=$genosub&\
REGION=$region&\
BASETYPE=$basetype&\
FORMAT=fasta&\
PRE_USER=predefined&\
submit"        
        curl -s --data "$d" https://www.hiv.lanl.gov/cgi-bin/NEWALIGN/align.cgi > tmp.txt
        echo "Download1 complete"
        l=$(cat tmp.txt | python parse_lanl_link.py)
        curl -s $l | python fix_lanl_align.py > $destdir/$basetype/${l##*/}
        echo "Download2 complete"
        rm -f tmp.txt
    done
done

# Genome
echo "$alntype $year $genosub GENOME DNA"

dg="ORGANISM=HIV&\
SUBORGANISM=$suborganism&\
ALIGN_TYPE=$alntype&\
YEAR=$year&\
GENO_SUB=$genosub&\
REGION=GENOME&\
BASETYPE=DNA&\
FORMAT=fasta&\
PRE_USER=predefined&\
submit"

curl -s --data "$dg" https://www.hiv.lanl.gov/cgi-bin/NEWALIGN/align.cgi > tmp.txt             
echo "Download1 complete"
l=$(cat tmp.txt | python parse_lanl_link.py)
curl -s $l | python fix_lanl_align.py > $destdir/GENOME/${l##*/}
echo "Download2 complete"
rm -f tmp.txt
