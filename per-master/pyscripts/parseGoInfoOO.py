from __future__ import division
import re

#define a class to represent go file
class goTerm(object):
    #define a constructor for the class
    def __init__(self, record):
	#search for the fields and group them and match them directly to is_a attribute
        fields = re.search(r"id:\s+(.*?)\nname:\s+(.*?)\nnamespace:\s+(.*?)\n", record, re.DOTALL)
        self.go_id = fields.group(1)
        self.name = fields.group(2)
        self.namespace = fields.group(3)
        self.is_a = re.findall(r"is_a:\s+(.*)", record)
    #define a print all method
    def printAll(self):
        line = self.namespace + "\n" + "\t" + self.name + "\n" + "\t"
        for isa in self.is_a:
            line += isa + "\n" + "\t"
        return self.go_id + "\t" + line

def split_file(input_file):
    #open the file object
    go_file = open(input_file)
    #read the file
    go_terms = go_file.read()
    #use findall to split the file
    split_terms = re.findall(r"\[Term\](.*?)\n\n", go_terms, re.DOTALL)
    for term in split_terms:
        go = goTerm(term)
        go_info[go.go_id] = go
    	go_file.close()

#initialize a go dictionary
go_info = {}

split_file(input_file= "/scratch/go-basic.obo")

for id in go_info.keys():
    print(go_info[id].printAll() + "\n")
