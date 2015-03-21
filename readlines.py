#!/usr/bin/env python

import csv

csvfile = open('quiz0v2p1.csv')
for line in csv.reader(csvfile):
  name = line[0]
  rest = line[1:]
  chars_per_answer = sum([len(x) for x in rest]) / float(len(rest))
  words_per_answer = sum([len(x.split(' ')) for x in rest]) / float(len(rest))
  lines_per_answer = sum([len(x.split('\n')) for x in rest]) / float(len(rest))
  #print chars_per_answer, name
  print lines_per_answer, name

