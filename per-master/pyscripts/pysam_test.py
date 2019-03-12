#!/Users/sai/miniconda2/bin/python
import pysam
import math
#from _future_ import division 
samfile = pysam.AlignmentFile("TEST1.bam","rb")
outfile = open("Final.txt",'w')
#QUESTION 2.
mapped = float( samfile.mapped)
bedmapped = float( pysam.view("-c","-L", "TEST1_region.bed", "TEST1.bam",catch_stdout=True))
percent =  (bedmapped/mapped)*100
print 'percent of reads enriched in target regions = ', "%.2f" %(percent)
############################
# QUestion 3
bedfile = open("TEST1_region.bed", 'r')
#basecount = 0
targetcount=0
basecount = 0
myhash= {}
pilereg = {}
regcov = {}
for line in bedfile.readlines():
	chrm,start,end,region = line.split("\t")
	region = region.strip('\r\n')
	targetlen = (int(end)- int(start))+1
	targetcount += targetlen
	regionbasecount = 0
	#basecount = 0
	for pile in samfile.pileup(chrm,int(start),int(end),**{"truncate":True}):
		basecount +=  pile.n
		regionbasecount += pile.n
	regcovdep = float(regionbasecount)/float(targetlen)
	regcov[region] = regcovdep	
	percent = round(float(regionbasecount)/float(targetlen),2)
	myhash[region] = percent
	pilereg[region] = regionbasecount
covsum = sum(myhash.values())
hashcount = len(myhash.keys())
covavg = round(float(covsum)/float(hashcount),2)
totalbases = 83782281.0
percent = (basecount/totalbases)*100
print 'Percent bases enriched in target regions = ',"%.2f" %(percent)
##########################################################
#QUESTION 5
# MEAN COVERAGE FOR EACH BASE IN ALL TARGET REGIONS.
meancoverage = float(basecount)/targetcount
print 'Mean Coverage = ', "%.2f" %(meancoverage)

###################
def que3():
	bedfile = open("TEST1_region.bed",'r')
	percentbase = 0
	for line in bedfile.readlines():
		chrm,start,end,region = line.split("\t")
		region = region.strip('\r\n')
		for pile in samfile.pileup(chrm,int(start),int(end),**{"truncate":True}):
		#	percentbase = 0
			if pile.n > (regcov[region]*0.2):
				percentbase += 1
	unicov = (float(percentbase)/float(targetcount))*100
	print 'uniformity of coverage ' "%.2f%%"%(unicov)
que3()

################
def myprint():
	bed = open("TEST1_region.bed",'r')
       #basetotal = round(float(sum(pilereg.values())/float(hashcount)))
	for line in bed.readlines():	
		chrm,start,end,region = line.split("\t")
		region = region.strip('\r\n')
		difference = myhash[region] - covavg
		sq_diff = difference**2
		var = sq_diff/(hashcount - 1)
		#print var
		stddev = round(math.sqrt(var),2)
		l = [chrm,start,end,region,str(myhash[region]),str(stddev)]
		outfile.write('\t'.join(l) + '\n')
myprint()

#######################################################
