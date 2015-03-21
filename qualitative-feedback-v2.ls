root = exports ? this

require! \fs

{sum, average} = require \prelude-ls

readFileLines = (filename) ->
  fs.readFileSync(filename, 'utf-8')

readResults = (filename1, filename2) ->
  output = []
  results1 = readLines filename1
  results2 = readlines filename2
  #output.userid = 

