#!/usr/bin/python3

import os
import subprocess as sp
import re
import json

HISEQHOME = "/home/ec2-user/uploads/Hiseq1"
OUTPUT = "/home/ec2-user/uploads/Hiseq_rerun"
CLASSIFICATION_CONFIG = "/home/ec2-user/biotools/scripts/config/classification.json"

def cleanup(files, pattern=False):
    if not pattern:
        print("For deletion: %s"% ','.join(files))
        for file in files:
            os.remove(file)
    else:
        print("For deletion: %s" % files)
        sp.run('rm -rf ' + files, shell=True)

def krakenrerun():
    for file in os.listdir(HISEQHOME):
        if not file.startswith('.'):
            file_abspath = "%s/%s"%(HISEQHOME, file)

            try:
                os.makedirs('%s/%s'%(OUTPUT, file))
            except FileExistsError:
                print('Folder Exists')

            with open(CLASSIFICATION_CONFIG, 'r') as f:
                param = json.load(f)

            sp.run(['kraken2', '--paired', '%s/%s_1.fastq'% (file_abspath,file), '%s/%s_2.fastq'%(file_abspath,file), \
            '--threads', param['threads'], '-output', '%s/%s/kraken_out'%(OUTPUT,file), \
            '--report', '%s/%s/%s_report'%(OUTPUT,file,file), '--db', '/home/ec2-user/databases/MY_KRAKEN_DATABASE'])


            cleanup('%s/%s/kraken_out'%(OUTPUT,file), True)


            sp.run(['est_abundance.py', '-i', '%s/%s/%s_report'%(OUTPUT, file, file), \
            '-k', '/home/ec2-user/databases/MY_KRAKEN_DATABASE/database150mers.kmer_distrib', \
            '-o', '%s/%s/%s.bracken' % (OUTPUT, file, file)])

            cleanup('%s/%s/%s.bracken' % (OUTPUT, file, file), True)

krakenrerun()