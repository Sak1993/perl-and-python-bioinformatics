from __future__ import division
class blast(object):
    def __init__(self, blast_line):
        fields = blast_line.rstrip("\n").split("\t")
        group1 = fields[0].split("|")
        group2 = fields[1].split("|")
        self.transcript = group1[0]
        self.isoform = group1[1]
        self.protein = group2[3].split(".")[0]
        self.identity = float(fields[2])

class matrix(object):
    def __init__(self, line):
        fields = line.rstrip("\n").split("\t")
        (transcript, self.Sp_ds,
         self.Sp_hs, self.Sp_log,
         self.Sp_plat) = fields
        self.protein = transcript
        if transcript in transcript_to_protein:
            self.protein = transcript_to_protein.get(transcript).protein

def identity_threshold(blast_obj):
    return blast_obj.identity > 95

def tuple_to_tab_sep(tuple):
    return "\t".join(tuple)

blast_file = open("/scratch/RNASeq/blastp.outfmt6")
blast_map = map(blast, blast_file.readlines())
filtered_blast = filter(identity_threshold, blast_map)
transcript_to_protein = {blast_obj.transcript:blast_obj
                         for blast_obj
                         in filtered_blast}
blast_file.close()

matrix_file = open("/scratch/RNASeq/diffExpr.P1e-3_C2.matrix")
matrix_map = map(matrix, matrix_file.readlines())
matrix_file.close()

for matrix_obj in matrix_map:
    print(tuple_to_tab_sep((matrix_obj.protein,
                                   matrix_obj.Sp_ds,
                                   matrix_obj.Sp_hs,
                                   matrix_obj.Sp_log,
                                   matrix_obj.Sp_log)) + "\n")
