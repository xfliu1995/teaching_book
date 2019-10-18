# 5.2.Structure Motif

## 1\) workflow

![](../../.gitbook/assets/structure_motif.pipeline.png)

## 2\) running steps

### \(1\) get interested sequence and control sequence as sequence motif analysis

### \(2\) BEAM

[http://www.beam.uniroma2.it](http://www.beam.uniroma2.it)

#### Use RNAfold to get dot-bracket

Compute the best \(MFE\) structure for this sequence \(primary sequence with dot-bracket\)

```text
RNAfold <test.fa >dot.fa
```

#### Get file with BEAR notation ---&gt; fastB \(fastBEAR\).

```text
awk '/^>/ {print; getline; print; getline; print $1}' dot.fa >dot_to_encode.fa
java -jar /BioII/lulab_b/songyabing/motif_analysis/software/BEAM/beam-2.0/BearEncoder.new.jar dot_to_encode.fa BEAMready.fa
```

#### get structure motifs

```text
java -jar /BioII/lulab_b/songyabing/motif_analysis/software/BEAM/beam-2.0/BEAM_release1.6.1.jar -f BEAMready.fa -w 10 -W 40 -M 3
```

#### visualize motifs with weblogo

**install weblogo**

```text
pip install weblogo
```

**visualize structure motifs**

```text
weblogo -a 'ZAQXSWCDEVFRBGTNHY' -f BEAMready_m1_run1_wl.fa -D fasta \
-o out.jpeg -F jpeg --composition="none" \
-C red ZAQ 'Stem' -C blue XSW 'Loop' -C forestgreen CDE 'InternalLoop' \
-C orange VFR 'StemBranch' -C DarkOrange B 'Bulge' \
-C lime G 'BulgeBranch' -C purple T 'Branching' \
-C limegreen NHY 'InternalLoopBranch'
```

#### example output

![](../../.gitbook/assets/structure_motif.beam.png)


### \(3\) other tools

#### GraphProt:modelling binding preferences of RNA-binding proteins

[https://github.com/dmaticzka/GraphProt](https://github.com/dmaticzka/GraphProt)

#### RNAcontext: A New Method for Learning the Sequence and Structure Binding Preferences of RNA-Binding Proteins

[http://www.cs.toronto.edu/~hilal/rnacontext/](http://www.cs.toronto.edu/~hilal/rnacontext/)

download the example input files from [structure\_motif](https://github.com/YuminTHU/training_class/tree/master/files/structure_motif)

