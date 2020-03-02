# 5.2.Structure Motif

## 1\) workflow

![](../../.gitbook/assets/structure_motif.pipeline.png)

## 2\) running steps

### 2a\) get interested sequences and background sequences

[文件和软件获取方式](./#files)

### 2b\) BEAM

[http://beam.uniroma2.it/home](http://beam.uniroma2.it/home)

```bash
docker exec -it -u root motif bash
# 在这个路径下已经准备了练习文件

cd /home/test/motif/structure_motif/BEAM
```

#### use RNAfold to get dot-bracket

Compute the best \(MFE\) structure for this sequence \(primary sequence with dot-bracket\)

```bash
RNAfold <test.fa >dot.fa
less dot.fa
# 查看生成的序列及点括号文件dot.fa
```

#### get file with BEAR notation ---&gt; fastB \(fastBEAR\).

```text
awk '/^>/ {print; getline; print; getline; print $1}' dot.fa >dot_to_encode.fa
java -jar /home/test/software/BEAM/beam-2.0/BearEncoder.new.jar dot_to_encode.fa BEAMready.fa
```

#### get structure motifs

```text
java -jar /home/test/software/beam-2.0/BEAM_release_1.5.1.jar -f BEAMready.fa -w 10 -W 40 -M 3
```

![](https://tva1.sinaimg.cn/large/006y8mN6ly1g85tflwz2qj30pw0citaq.jpg)

#### visualize motifs with weblogo

```bash
cd /home/test/motif/structure_motif/BEAM/risultati/BEAMready/webLogoOut/motifs
weblogo -a 'ZAQXSWCDEVFRBGTNHY' -f BEAMready_m1_run1_wl.fa -D fasta \
-o out.jpeg -F jpeg --composition="none" \
-C red ZAQ 'Stem' -C blue XSW 'Loop' -C forestgreen CDE 'InternalLoop' \
-C orange VFR 'StemBranch' -C DarkOrange B 'Bulge' \
-C lime G 'BulgeBranch' -C purple T 'Branching' \
-C limegreen NHY 'InternalLoopBranch'
cp out.jpeg /data
# 进入share文件夹查看输出结果
```

> example output ![](https://tva1.sinaimg.cn/large/006y8mN6ly1g85thyjml0j30ok08sgo9.jpg)

## 3\) other tools

* **RNApromo**

[https://genie.weizmann.ac.il/pubs/rnamotifs08/64bit\_exe\_rnamotifs08\_motif\_finder.tar.gz](https://genie.weizmann.ac.il/pubs/rnamotifs08/64bit_exe_rnamotifs08_motif_finder.tar.gz)

* **GraphProt**

modelling binding preferences of RNA-binding proteins: [https://github.com/dmaticzka/GraphProt](https://github.com/dmaticzka/GraphProt)

* **RNAcontext**

A New Method for Learning the Sequence and Structure Binding Preferences of RNA-Binding Proteins: [http://www.cs.toronto.edu/~hilal/rnacontext/](http://www.cs.toronto.edu/~hilal/rnacontext/)

## 4\) Homework

* 解释可视化的structure motif中不同字符的含义。可参考相应的文献或是网站。

