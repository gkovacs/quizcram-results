import json
#from numpy import mean, stddev
from scipy.stats import ttest_rel
import numpy

usernames = ["sydneyosifeso", "jiawenli", "lorant", "yanyan", "ngocbui", "celinajackson", "dorondorfman", "angelicachavez", "crystalromero", "jonathangriffin", "michelleloya", "johnnyxu"]
usernames_set = set(usernames)
# exclude bc didn't do all the questions: angilewis1
# 18 users, but only 11 because missing meo + excluded angilewis1 marcellaweiss1 annereynolds dinianapiekutowski emilytruong angelicachavez
user_to_num_answers = {}
user_to_invideo_answers = {}
user_to_invideo_answers_correct = {}
user_to_quizcram_answers = {}
user_to_quizcram_answers_correct = {}
user_to_quizcram_extra_answers = {}
user_to_quizcram_extra_answers_correct = {}

user_to_invideo_seek = {}
user_to_quizcram_seek = {}
user_to_quizcram_skip_to_end_of_seen_portion = {}

user_to_invideo_qidx_first_answered = {}
user_to_quizcram_qidx_first_answered = {}
user_to_quizcram_extra_qidx_first_answered = {}

user_to_invideo_question_reviewed = {}
user_to_quizcram_question_reviewed = {}

user_to_quizcram_extra_question_reviewed = {}

for user in usernames:
  user_to_num_answers[user] = 0
  user_to_invideo_answers[user] = 0
  user_to_invideo_answers_correct[user] = 0
  user_to_quizcram_answers[user] = 0
  user_to_quizcram_answers_correct[user] = 0
  user_to_quizcram_extra_answers[user] = 0
  user_to_quizcram_extra_answers_correct[user] = 0
  user_to_invideo_seek[user] = 0
  user_to_quizcram_seek[user] = 0
  user_to_quizcram_skip_to_end_of_seen_portion[user] = 0
  user_to_invideo_qidx_first_answered[user] = {}
  user_to_quizcram_qidx_first_answered[user] = {}
  user_to_quizcram_extra_qidx_first_answered[user] = {}
  user_to_invideo_question_reviewed[user] = 0
  user_to_quizcram_question_reviewed[user] = 0
  user_to_quizcram_extra_question_reviewed[user] = 0

# also keep track of: amount of seeking activity total, amount of video reviewing / rewatches, etc

invideo_answers = 0
invideo_answers_correct = 0
quizcram_answers = 0
quizcram_answers_correct = 0
quizcram_extra_answers = 0
quizcram_extra_answers_correct = 0

quizcram_optional_qidx_half1 = [3, 4, 7, 8, 10, 11, 12, 15, 16]
quizcram_optional_qidx_half2 = [2, 5, 7, 8, 9, 11, 13]
# var extra_idxes = []; for (var i = 0; i < questions.length; ++i) { if (questions[i].extra) { extra_idxes.push(i)} }
# 10 normal questions in half 1
# 7 normal questions in half 2

event_types = []

#for line in open('mongoexportlocal_2014-09-23_07:06:21-04:00.json'):
for line in open('mongoexportlocal_2014-09-21_06:49:23-04:00.json'):
  data = json.loads(line)
  if data['username'] not in usernames_set:
    continue
  user = data['username']
  event = data['event']
  #if event not in event_types:
  #  event_types.append(event)
  #print data['event']
  #if event == 'switchvideo':
  #  print data
  #continue
  if data['event'] == 'skipToEndOfSeenPortion':
    user_to_quizcram_skip_to_end_of_seen_portion[user] += 1
    continue
  if data['event'] == 'seek':
    if data['platform'] == 'quizcram':
      user_to_quizcram_seek[user] += 1
    else:
      user_to_invideo_seek[user] += 1
    continue
  if data['event'] != 'check':
    continue
  qidx = data['qidx']
  time = data['time']
  #print data
  #continue
  user_to_num_answers[user] += 1
  if data['platform'] == 'invideo':
    if data['correct']:
      invideo_answers_correct += 1
      user_to_invideo_answers_correct[user] += 1
    invideo_answers += 1
    user_to_invideo_answers[user] += 1
  isextra = False
  if data['platform'] == 'quizcram':
    if data['course'] == 'neuro_1' and data['qidx'] in quizcram_optional_qidx_half1:
      isextra = True
    if data['course'] == 'neuro_2' and data['qidx'] in quizcram_optional_qidx_half2:
      isextra = True
    if not isextra:
      if data['correct']:
        quizcram_answers_correct += 1
        user_to_quizcram_answers_correct[user] += 1
      quizcram_answers += 1
      user_to_quizcram_answers[user] += 1
    if isextra:
      if data['correct']:
        quizcram_extra_answers_correct += 1
        user_to_quizcram_extra_answers_correct[user] += 1
      quizcram_extra_answers += 1
      user_to_quizcram_extra_answers[user] += 1
  if not isextra:
    if data['platform'] == 'invideo':
      if qidx not in user_to_invideo_qidx_first_answered[user]:
        user_to_invideo_qidx_first_answered[user][qidx] = time
      if time >= user_to_invideo_qidx_first_answered[user][qidx] + 1000*60: # at least 1 minute has elapsed
        user_to_invideo_question_reviewed[user] += 1
    else:
      if qidx not in user_to_quizcram_qidx_first_answered[user]:
        user_to_quizcram_qidx_first_answered[user][qidx] = time
      if time >= user_to_quizcram_qidx_first_answered[user][qidx] + 1000*60: # at least 1 minute has elapsed
        user_to_quizcram_question_reviewed[user] += 1
  if isextra:
    if data['platform'] == 'quizcram':
      if qidx not in user_to_quizcram_extra_qidx_first_answered[user]:
        user_to_quizcram_extra_qidx_first_answered[user][qidx] = time
      if time >= user_to_quizcram_extra_qidx_first_answered[user][qidx] + 1000*60: # at least 1 minute has elapsed
        user_to_quizcram_extra_question_reviewed[user] += 1
  #print line
  #print data['event']
  #if data['event'] == 'questionscore':
  #  print data['platform']
  #if data['platform'] == 'quizcram':
  #  print data['event']
  #if data['platform'] == 'invideo':
    #print data['event']
    #print check[]
    #if data['event'] == 'check':
      #print line

print event_types

def avgvals(d):
  return numpy.mean(d.values())

def ttestvals(d1, d2):
  l1 = [d1[x] for x in usernames]
  l2 = [d2[x] for x in usernames]
  return ttest_rel(l1, l2)

#print 'invideo_answers_correct', invideo_answers_correct, float(invideo_answers_correct) / invideo_answers
print 'invideo_answers_correct', avgvals(user_to_invideo_answers_correct), float(avgvals(user_to_invideo_answers_correct)) / avgvals(user_to_invideo_answers)
#print 'invideo_answers', invideo_answers
print 'invideo_answers', avgvals(user_to_invideo_answers)
#print 'quizcram_answers_correct', quizcram_answers_correct, float(quizcram_answers_correct) / quizcram_answers
print 'quizcram_answers_correct', avgvals(user_to_quizcram_answers_correct), float(avgvals(user_to_quizcram_answers_correct)) / avgvals(user_to_quizcram_answers)
#print 'quizcram_answers', quizcram_answers
print 'quizcram_answers', avgvals(user_to_quizcram_answers)
#print 'quizcram_extra_answers_correct', quizcram_extra_answers_correct, float(quizcram_extra_answers_correct) / quizcram_extra_answers
print 'quizcram_extra_answers_correct', avgvals(user_to_quizcram_extra_answers_correct), float(avgvals(user_to_quizcram_extra_answers_correct)) / avgvals(user_to_quizcram_extra_answers)
#print 'quizcram_extra_answers', quizcram_extra_answers
print 'quizcram_extra_answers', avgvals(user_to_quizcram_extra_answers)

print 't-tests:'
print 'invideo vs quizcram on original questions:', ttestvals(user_to_quizcram_answers, user_to_invideo_answers)
print 'invideo vs quizcram correct on original questions:', ttestvals(user_to_quizcram_answers_correct, user_to_invideo_answers_correct)
#print user_to_num_answers

print 'seeking:'
print 'invideo seeking:', avgvals(user_to_invideo_seek)
print 'quizcram seeking:', avgvals(user_to_quizcram_seek)
print 'invideo vs quizcram on seeking:', ttestvals(user_to_quizcram_seek, user_to_invideo_seek)
print 'quizcram skip to end of seen portion:', avgvals(user_to_quizcram_skip_to_end_of_seen_portion)

print 'queston reviewed:'
print 'user_to_invideo_question_reviewed', avgvals(user_to_invideo_question_reviewed)
print 'user_to_quizcram_question_reviewed', avgvals(user_to_quizcram_question_reviewed)
print 'invideo vs quizcram on question reviewing:', ttestvals(user_to_quizcram_question_reviewed, user_to_invideo_question_reviewed)
print 'user_to_quizcram_extra_question_reviewed', avgvals(user_to_quizcram_extra_question_reviewed)