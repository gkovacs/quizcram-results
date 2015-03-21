firsthalf_text = '''6 minh1
3 angelicachavez
6 nathanjones1
6 sakshisundaram1
5 angilewis1
5 marcellaweiss1
4 dionnejackson
3 johnnyxu
7 jiawenli
3 annereynolds
5 lorant
5 dinianapiekutowski
2 emilytruong
5 celinajackson
7 crystalromero
4 yanyan
7 michelleloya
6 dorondorfman
7 ngocbui
5 jonathangriffin
6 sydneyosifeso
4 sarahsimmons'''

firsthalf = {}
for line in firsthalf_text.split('\n')
  [percent,...,user] = line.split ' '
  firsthalf[user] = parseFloat percent

secondhalf_text = '''6  minh1
7 angelicachavez
4 marcellaweiss1
6 angilewis1
5 johnnyxu
6 jiawenli
6 annereynolds
6 lorant
6 dinianapiekutowski
7 emilytruong
7 crystalromero
5 yanyan
7 michelleloya
1 dorondorfman
4 celinajackson
5 ngocbui
3 jonathangriffin
6 sydneyosifeso'''

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


