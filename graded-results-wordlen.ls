firsthalf_text = '''4.88888888889 angelicachavez
13.8888888889 minh1
1.22222222222 nathanjones1
6.88888888889 angilewis1
5.44444444444 marcellaweiss1
23.4444444444 sakshisundaram1
5.33333333333 johnnyxu
6.33333333333 jiawenli
6.77777777778 lorant
19.4444444444 annereynolds
8.77777777778 emilytruong
15.7777777778 dinianapiekutowski
5.0 dorondorfman
5.33333333333 yanyan
10.0 celinajackson
13.5555555556 crystalromero
13.0 michelleloya
13.3333333333 ngocbui
8.11111111111 jonathangriffin
5.0 sydneyosifeso
10.3333333333 sarahsimmons'''

firsthalf = {}
for line in firsthalf_text.split('\n')
  [percent,...,user] = line.split ' '
  firsthalf[user] = parseFloat percent

secondhalf_text = '''12.4285714286 angelicachavez
17.5714285714 minh1
7.14285714286 nathanjones1
13.8571428571 angilewis1
8.42857142857 marcellaweiss1
42.2857142857 sakshisundaram1
20.2857142857 johnnyxu
8.71428571429 jiawenli
18.1428571429 lorant
27.8571428571 annereynolds
17.1428571429 emilytruong
27.8571428571 dinianapiekutowski
10.5714285714 dorondorfman
11.0 yanyan
14.1428571429 celinajackson
21.7142857143 crystalromero
13.4285714286 michelleloya
24.0 ngocbui
10.7142857143 jonathangriffin
19.8571428571 sarahsimmons
9.85714285714 sydneyosifeso'''

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


