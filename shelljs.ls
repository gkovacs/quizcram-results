console.log 'foo'
shell = require('shelljs')
console.log 'bar'
console.log shell.exec('ls')
console.log 'baz'
