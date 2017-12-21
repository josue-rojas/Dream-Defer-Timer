import os
import requests
import json
import time

# this script is to update data
# this should run everyday using crontab
# https://ole.michelsen.dk/blog/schedule-jobs-with-crontab-on-mac-osx.html

# SECRET_URL = 'http://dream-deferred.herokuapp.com' + os.environ['SECRET_URL']
SECRET_URL = 'http://dream-deferred.herokuapp.com' + os.environ['SECRET_URL']
project_root = '/'.join(os.getcwd().split('/')[:-1])
resource_folder = project_root + '/resources/'
dataOut = resource_folder + '2309ru88uyf384.json'
orderOut = resource_folder+  '2d341dui2udibe.json'

r = requests.get(SECRET_URL)
allTimers = r.json()
validTimers = allTimers[:]


# keep track to send delete query (should just be one..)
deleteTimer = []

# json out with ids being keys for quick access to information
orderOutDICT = dict([])

# instagram check if multiple
instagram = []

# first filter out the expire ones
# if not expire then add to the orderOutDICT
# else remove from json and put in list to be deleted
i = 0
pop = 0
for timer in allTimers:
    if time.time() < timer['dateend'] and not (timer['insta'] in instagram):
        instagram += [timer['insta']]
        orderOutDICT.setdefault(timer['id'], timer)
    else:
        deleteTimer += [timer['id']]
        validTimers.pop(i-pop)
        pop +=1
    i+=1

payload = {'delete': deleteTimer }
headers = {'content-type': 'application/json'}
rDel = requests.delete(SECRET_URL+'/delete', data=json.dumps(payload),headers=headers)

# delete single id (i used for testing)
# rDel = requests.delete(SECRET_URL+'/delete/1')
# print rDel


print 'deleted ids'
print deleteTimer


with open(dataOut, 'w') as outfile:
    json.dump(validTimers, outfile)

with open(orderOut, 'w') as outfile:
    json.dump(orderOutDICT, outfile)
