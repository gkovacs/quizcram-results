firsthalf_text = '''0.7498888889  angelicachavez
0.8332222222  minh1
0.05555555556  nathanjones1
0.09255555556  angilewis1
0.6295555556  marcellaweiss1
0.9628888889  sakshisundaram1
0.5925555556  johnnyxu
0.8147777778  jiawenli
0.4626666667  lorant
0.2406666667  annereynolds
0.9444444444  emilytruong
0.7222222222  dinianapiekutowski
0.1666666667  dorondorfman
0.1758888889  yanyan
0.6111111111  celinajackson
0.8611111111  crystalromero
0.6294444444  michelleloya
1  ngocbui
0.6201111111  jonathangriffin
0.5462222222  sydneyosifeso
0.7035555556  sarahsimmons'''

firsthalf = {}
for line in firsthalf_text.split('\n')
  [percent,...,user] = line.split ' '
  firsthalf[user] = parseFloat percent

secondhalf_text = '''0.5118571429 angelicachavez
1 minh1
0.3094285714  nathanjones1
0.7498571429  angilewis1
0.369 marcellaweiss1
0.5831428571  sakshisundaram1
0.5 johnnyxu
0.3571428571  jiawenli
0.5714285714  lorant
0.6784285714  annereynolds
0.7261428571  emilytruong
0.5118571429  dinianapiekutowski
0.1428571429  dorondorfman
0.3808571429  yanyan
0.3808571429  celinajackson
0.7261428571  crystalromero
0.6665714286  michelleloya
0.8571428571  ngocbui
0.4404285714  jonathangriffin
0.5118571429  sarahsimmons
0.7141428571  sydneyosifeso'''

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


