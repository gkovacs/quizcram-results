#!/usr/bin/python

from sys import argv
from scipy.stats import ttest_rel, ttest_ind
import json

g1 = json.loads(argv[1])
g2 = json.loads(argv[2])

print ttest_rel(g1, g2)
