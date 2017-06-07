#! /usr/bin/env python
import sys
from Bio import SeqIO
okres = '-GALMFWKQESPVICYHRNDTX*' + 'B'
seqs = [s for s in SeqIO.parse(sys.stdin, 'fasta')]
alnlen = max(len(s) for s in seqs)
print >>sys.stderr, 'Alignment length: %d' % alnlen
for s in seqs:
    ss = str(s.seq)
    while len(ss) < alnlen:
        ss += '-'
    ss = ss.replace('#', 'X')
    if any(b not in okres for b in ss):
        print >>sys.stderr, "WARNING: %s" % ss
    print >>sys.stdout, '>%s\n%s' % (s.id, ss)
