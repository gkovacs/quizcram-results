root = exports ? this

require! \fs

{sum, average} = require \prelude-ls

toQuestionAndUserInfo = (filename) ->
  lines = fs.readFileSync(filename, \utf-8).split('\n')

  question_info = []
  question_indexes = {}

  username_idx = null

  for column_text,idx in lines[0].split('\t')
    if column_text.indexOf('时间戳记') != -1
      continue
    if column_text.indexOf('Microsoft alias') != -1
      username_idx = idx
      continue
    if column_text.indexOf('Which of the following are true of cell membranes?') != -1
      continue # blacklisted question
    # is question!
    question_indexes[idx] = true
    question_info.push { idx: idx, text: column_text }

  if not username_idx?
    throw 'does not have username_idx'

  isLower = (c) ->
    return [\a to \z].indexOf(c) != -1

  isUpper = (c) ->
    return [\A to \Z].indexOf(c) != -1

  splitAnswers = (answers) ->
    output = []
    curgroup = []
    parts = answers.split(', ')
    for part,idx in parts
      if part.trim() == ''
        continue
      if isUpper(part[0])
        if curgroup.length > 0
          output.push curgroup.join(', ')
          curgroup = []
        curgroup.push part
      else
        curgroup.push part
    if curgroup.length > 0
      output.push curgroup.join(', ')
      curgroup = []
    return output

  user_info = []

  reference_user_idx = null
  allchecked_user_idx = null

  for row_text,idx in lines[1 to]
    cells = row_text.split('\t')
    username = cells[username_idx]
    question_answers = []
    for cell_text,idx in cells
      if not question_indexes[idx]?
        continue
      question_answers.push splitAnswers(cell_text)
    user_info.push { username, question_answers }

  for uinfo,idx in user_info
    if uinfo.username == 'reference'
      reference_user_idx = idx
    if uinfo.username == 'allchecked'
      allchecked_user_idx = idx

  if not reference_user_idx?
    throw 'need reference user'

  if not allchecked_user_idx?
    throw 'need allchecked user'

  listContains = (list, item) ->
    return list.indexOf(item) != -1

  scoreAnswers = (myanswers, refanswers, allanswers) ->
    num_correct = 0
    total = allanswers.length
    for option in allanswers
      minechecked = listContains(myanswers, option)
      refchecked = listContains(refanswers, option)
      if minechecked == refchecked
        num_correct += 1
    return num_correct / total

  for uinfo,idx in user_info
    uinfo.scores = []
    for answers,question_idx in uinfo.question_answers
      reference_answers = user_info[reference_user_idx].question_answers[question_idx]
      all_answers = user_info[allchecked_user_idx].question_answers[question_idx]
      uinfo.scores.push scoreAnswers(answers, reference_answers, all_answers)
    uinfo.average_score = sum(uinfo.scores) / uinfo.scores.length

  return [question_info, user_info]

uinfoForUser = (username, user_info) ->
  output = null
  for uinfo in user_info
    if uinfo.username == username
      output = uinfo
  return output

avgForUser = (username, user_info) ->
  output = null
  for uinfo in user_info
    if uinfo.username == username
      output = uinfo
  return output.average_score

do ->
  [question_info_1, user_info_1] = toQuestionAndUserInfo('quiz1.tsv')
  [question_info_2, user_info_2] = toQuestionAndUserInfo('quiz2.tsv')
  conditions = {
    'v-kaliao': 0
    'v-wancha': 1
    'v-mingll': 0
    'v-junfu': 1
    'v-huayan': 0
    'v-yumli': 1
    'cz1054858201@hotmail.com': 1
    'ztt0903@foxmail.com': 0
    'canjian ning': 0
  }
  #usernames = [uinfo.username for uinfo in user_info_2]
  usernames0 = [username for username,condition of conditions when condition == 0]
  usernames1 = [username for username,condition of conditions when condition == 1]
  invideo_part1 = [avgForUser(user, user_info_1) for user in usernames0]
  console.log 'invideo_part1:' + average(invideo_part1)
  quizcram_part1 = [avgForUser(user, user_info_1) for user in usernames1]
  console.log 'quizcram_part1:' + average(quizcram_part1)
  invideo_part2 = [avgForUser(user, user_info_2) for user in usernames1]
  console.log 'invideo_part2:' + average(invideo_part2)
  quizcram_part2 = [avgForUser(user, user_info_2) for user in usernames0]
  console.log 'quizcram_part2:' + average(quizcram_part2)
  #for username in usernames0
  #  uinfo1 = uinfoForUser username, user_info_1
  #  uinfo2 = uinfoForUser username, user_info_2
  #  console.log username + ': ' + uinfo1.average_score + ' | ' + uinfo2.average_score + ' | ' + (uinfo1.average_score > uinfo2.average_score)

