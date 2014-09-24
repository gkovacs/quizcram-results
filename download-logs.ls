{exec} = require \shelljs

for let user in <[minh1 angelicachavez nathanjones1 marcellaweiss1 angilewis1 sakshisundaram1 johnnyxu jiawenli lorant annereynolds emilytruong dinianapiekutowski dorondorfman yanyan celinajackson crystalromero michelleloya ngocbui jonathangriffin sarahsimmons sydneyosifeso]>
  console.log user
  exec "wget 'http://geza.csail.mit.edu:8080/viewlog?username=#{user}' -O 'logs-#{user}.txt'"
