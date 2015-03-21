firsthalf_text = '''36.8888888889 angelicachavez
99.4444444444 minh1
4.44444444444 nathanjones1
46.8888888889 angilewis1
33.6666666667 marcellaweiss1
142.666666667 sakshisundaram1
31.6666666667 johnnyxu
43.0 jiawenli
45.1111111111 lorant
108.111111111 annereynolds
64.8888888889 emilytruong
93.2222222222 dinianapiekutowski
33.7777777778 dorondorfman
35.5555555556 yanyan
55.4444444444 celinajackson
89.0 crystalromero
93.8888888889 michelleloya
83.4444444444 ngocbui
55.6666666667 jonathangriffin
44.7777777778 sydneyosifeso
67.0 sarahsimmons'''

firsthalf = {}
for line in firsthalf_text.split('\n')
  [percent,...,user] = line.split ' '
  firsthalf[user] = parseFloat percent

secondhalf_text = '''73.2857142857 angelicachavez
123.142857143 minh1
38.4285714286 nathanjones1
97.5714285714 angilewis1
49.8571428571 marcellaweiss1
255.857142857 sakshisundaram1
117.428571429 johnnyxu
50.7142857143 jiawenli
122.0 lorant
153.714285714 annereynolds
110.714285714 emilytruong
160.428571429 dinianapiekutowski
64.4285714286 dorondorfman
63.4285714286 yanyan
80.5714285714 celinajackson
131.857142857 crystalromero
86.0 michelleloya
142.714285714 ngocbui
68.0 jonathangriffin
119.428571429 sarahsimmons
69.4285714286 sydneyosifeso'''

secondhalf = {}
for line in secondhalf_text.split('\n')
  [percent,...,user] = line.split ' '
  secondhalf[user] = parseFloat percent

console.log firsthalf
console.log secondhalf

exec = require(\shelljs).exec

ttest_rel = (list_a, list_b) ->
  return exec("python ttest_rel.py '" + JSON.stringify(list_a) + "' '" + JSON.stringify(list_b) +  "'").output

{average} = require \prelude-ls

{conditions} = require \./conditionsv2

quizcram_results = []
invideo_results = []
firsthalf_results = []
secondhalf_results = []
for user,condition of conditions
  score1 = firsthalf[user]
  score2 = secondhalf[user]
  if not score1?
    console.log user
  if not score2?
    console.log user
  firsthalf_results.push score1
  secondhalf_results.push score2
  switch condition
  | 0 =>
    quizcram_results.push score2
    invideo_results.push score1
  | 1 =>
    quizcram_results.push score1
    invideo_results.push score2

console.log quizcram_results
console.log invideo_results

console.log 'quizcram:'
console.log average(quizcram_results)
console.log 'invideo:'
console.log average(invideo_results)
console.log 'ttest:'
console.log ttest_rel(quizcram_results, invideo_results)

console.log 'part1:'
console.log average(firsthalf_results)
console.log 'part2:'
console.log average(secondhalf_results)
console.log 'ttest:'
console.log ttest_rel(firsthalf_results, secondhalf_results)


