from __future__ import division
#function to parse blast file
def parse_blast(blast_line="NA"):
	line = blast_line.rstrip("\n").split("\t")
	qseq_id = line[0]
	sseq_id = line[1]
	(transcript, isoform) = qseq_id.split("|")
	sseq_id = sseq_id.split("|")
	swiss_prot_id = sseq_id[3]
	(protein_id, swiss_prot_ver) = swiss_prot_id.split(".")
	return(transcript, protein_id)

#creates the transcript_to_protein dictionary
transcript_to_protein = {}

#opens the blast file
blast_file = open("/scratch/RNASeq/blastp.outfmt6")

#reading the blast file line by line
blast_lines = blast_file.readlines()

#looping through the line one by one
for line in blast_lines:
	(transcript, protein_id) = parse_blast(blast_line=line)
	transcript_to_protein[transcript] = protein_id

#opens the matrix file
matrix_file = open("/scratch/RNASeq/diffExpr.P1e-3_C2.matrix")

#reading the file line by line
matrix_lines = matrix_file.readlines()

#looping throught lines one at a time
for line in matrix_lines:
	matrix = line.rstrip("\n").split("\t")
	if len(matrix) == 5: 
		(transcript, Sp_ds, Sp_hs, Sp_log, Sp_plat) = matrix
		protein = transcript_to_protein.get(transcript, transcript)
		tab = "\t"
		fields = (protein, Sp_ds, Sp_hs, Sp_log, Sp_plat)
		
		#printing the outputs
		print(tab.join(fields))
