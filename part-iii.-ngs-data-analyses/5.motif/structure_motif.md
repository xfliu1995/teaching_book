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

### \(3\) RNApromo

#### download

[https://genie.weizmann.ac.il/pubs/rnamotifs08/64bit\_exe\_rnamotifs08\_motif\_finder.tar.gz](https://genie.weizmann.ac.il/pubs/rnamotifs08/64bit_exe_rnamotifs08_motif_finder.tar.gz)

#### predict structure motifs

```text
rnamotifs08_motif_finder.pl -positive_seq input_pos_seq.fa -output_dir Output
```

**input**

Positive sequences - a fasta format file containing the sequences to predict motifs on.

```text
>Pos_1
ATAAGAGACCACAAGCGACCCGCAGGGCCAGACGTTCTTCGCCGAGAGTCGTCGGGGTTTCCTGCTTCAACAGTGCTTGGACGGAACCCGGCGCTCGTTCCCCACCCCGGCCGGCCGCCCATAGCCAGCCCTCCGTCACCTCTTCACCGCACCCTCGGACTGCCCCAAGGCCCCCGCCGCCGCTCCA
```

**example output**

![](../../.gitbook/assets/structure_motif.rnapromo.png)

#### find known motifs

After learning a motif, you can search a database of sequences to find positions that match the motif you learned. To do that you need to first match a secondary structure to each of the input sequences in your database, either using existing structure prediction algorithms, or using some other information.

**Produce a likelihood score for each sequence in the database.**

```text
rnamotifs08_motif_match.pl database.tab -cm model.cm
```

**input**

The database is then specified in the following format: database.tab

```text
seq_1    AUAAGAGACCACAAGCGACCCGCAGGGCCAGACGUUCUUCGCCGAGAGUCGUCGGGGUUUCCUGCUUCAACAGUGCUUGGACGGAACCCGGCGCUCGUUCCCCACCCCGGCCGGCCGCCCAUAGCCAGCCCUCCGUCACCUCUUCACCGCACCCUCGGACUGCCCCAAGGCCCCCGCCGCCGCUCCA    .............((((..(.((.(((((.(((((((((....))))).))))(((((.((((((...(((((((((.((......)).)))))).))).........(((.(((........))).)))..................))).....)))..)))))..)))))..)).).))))...
```

**output**

```text
seq_2:0    19.7698
seq_7:0    19.3706
seq_3:0    19.1064
seq_1:0    18.073
seq_5:0    16.5508
seq_9:0    14.5906
seq_4:0    10.3685
seq_10:0   9.15077
seq_6:0    6.81294
seq_8:0    0.233537
```

**Produce a likelihood score for the best motif position in each sequence in the database, and the position itself.**

**output**

```text
seq_2:0    19.7698    33      48      UUCAACAGUGUUUGGA        (((((......)))))        <<<<<,,,,,,>>>>>
seq_7:0    19.3706    104     119     GGGAGCAGUGUCUUCC        (((((......)))))        <<<<<,,,,,,>>>>>
seq_3:0    19.1064    16      31      GUCCUCAGUGCAGGGC        (((((......)))))        <<<<<,,,,,,>>>>>
seq_1:0    18.073     30      52      GACGUUCUUCGCCGAGAGUCGUC (((((((((....))))).)))) <<<<<<<<<,--->>>>>,>>>>
seq_5:0    16.5508    104     119     AGCUACAGUGUUAGCU        (((((......)))))        <<<<<,,,,,,>>>>>
seq_9:0    14.5906    32      47      GAGCCAGUGUGUUUCU        ((((......))))..        <<<-,,,,,,->>>,,
seq_4:0    10.3685    7       21      UUGUCAGUGCACAAA         ((((......)))).         <<<<,,,,,,>>>>,
seq_10:0   9.15077    133     152     CAACCUCCACCUUCUGGGUU    .(((((.........)))))    ,<----,,,,,,,,,---->
seq_6:0    6.81294    1       16      UAUGGAGAUUUCCAUA        (((((......)))))        <<<<<,,,,,,>>>>>
seq_8:0    0.233537   95      115     ACACCCCAGCCCUGCAGUGUA   ((((..((....))..)))).   <<<<,,--,,,,---->>>>,
```

### \(4\) other tools

#### GraphProt:modelling binding preferences of RNA-binding proteins

[https://github.com/dmaticzka/GraphProt](https://github.com/dmaticzka/GraphProt)

#### RNAcontext: A New Method for Learning the Sequence and Structure Binding Preferences of RNA-Binding Proteins

[http://www.cs.toronto.edu/~hilal/rnacontext/](http://www.cs.toronto.edu/~hilal/rnacontext/)

download the example input files from [structure\_motif](https://github.com/YuminTHU/training_class/tree/master/files/structure_motif)

