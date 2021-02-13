from __future__ import print_function
import time
from os import system
from activity import *
import json
import datetime
import sys

import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

# Use the application default credentials
cred = credentials.Certificate("cred.json")
firebase_admin.initialize_app(cred)

db = firestore.client()


if sys.platform in ['Windows', 'win32', 'cygwin']:
    import win32gui
    import uiautomation as auto
elif sys.platform in ['Mac', 'darwin', 'os2', 'os2emx']:
    from AppKit import NSWorkspace
    from Foundation import *
elif sys.platform in ['linux', 'linux2']:
        import linux as l

active_window_name = ""
activity_name = ""
start_time = datetime.datetime.now()
activeList = AcitivyList([])
first_time = True


def url_to_name(url):
    string_list = url.split('/')
    return string_list[2]


def get_active_window():
    _active_window_name = None
    if sys.platform in ['Windows', 'win32', 'cygwin']:
        window = win32gui.GetForegroundWindow()
        _active_window_name = win32gui.GetWindowText(window).split(' - ')
    elif sys.platform in ['Mac', 'darwin', 'os2', 'os2emx']:
        _active_window_name = (NSWorkspace.sharedWorkspace()
                               .activeApplication()['NSApplicationName'])
    else:
        print("sys.platform={platform} is not supported."
              .format(platform=sys.platform))
        print(sys.version)
    return _active_window_name[-1]


def get_chrome_url():
    if sys.platform in ['Windows', 'win32', 'cygwin']:
        window = win32gui.GetForegroundWindow()
        chromeControl = auto.ControlFromHandle(window)
        edit = chromeControl.EditControl()
        return 'https://' + edit.GetValuePattern().Value
    elif sys.platform in ['Mac', 'darwin', 'os2', 'os2emx']:
        textOfMyScript = """tell app "google chrome" to get the url of the active tab of window 1"""
        s = NSAppleScript.initWithSource_(
            NSAppleScript.alloc(), textOfMyScript)
        results, err = s.executeAndReturnError_(None)
        return results.stringValue()
    else:
        print("sys.platform={platform} is not supported."
              .format(platform=sys.platform))
        print(sys.version)
    return _active_window_name

try:
    activeList.initialize_me(db)
except Exception:
    print('No json')


try:
    while True:
        previous_site = ""
        if sys.platform not in ['linux', 'linux2']:
            new_window_name = get_active_window()
            if 'Google Chrome' in new_window_name:
                new_window_name = url_to_name(get_chrome_url())
        if sys.platform in ['linux', 'linux2']:
            new_window_name = l.get_active_window_x()
            if 'Google Chrome' in new_window_name:
                new_window_name = l.get_chrome_url_x()

        
        if active_window_name != new_window_name:
            print(active_window_name)
            activity_name = active_window_name

            if not first_time:
                end_time = datetime.datetime.now()
                time_entry = TimeEntry(start_time, end_time, 0, 0, 0, 0)
                time_entry._get_specific_times()
                doc_ref = db.collection(u'jyotigorherkar@gmail.com').document(u'activity')
                curr_date = str(datetime.datetime.now().date())
                exists = False
                for activity in activeList.activities:
                    if activity.name == activity_name:
                        exists = True
                        activity.time_entries.append(time_entry)
                if not exists:
                    activity = Activity(activity_name, [time_entry])
                    activeList.activities.append(activity)

                doc = doc_ref.get()
                if(doc.exists):
                    data = doc.to_dict()["Date"]
                    data[curr_date] = activeList.serialize()
                    doc_ref.update({
                        u'Date': data
                    })
                
            first_time = False
            active_window_name = new_window_name

        time.sleep(1)
    
except KeyboardInterrupt:
    doc_ref = db.collection(u'jyotigorherkar@gmail.com').document(u'activity')
    curr_date = str(datetime.datetime.now().date())
    if(doc.exists):
        data = doc.to_dict()["Date"]
        data[curr_date] = activeList.serialize()
        doc_ref.update({
            u'Date': data
        })
