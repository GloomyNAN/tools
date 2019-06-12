#!/usr/bin/python
#encoding=utf-8

#MD5批量查找去重
#import the modules
import os
import os.path
import sys
import hashlib

#define the functions
def findFile(rootPath, fileSeq, delSeq):
    dirs = os.listdir(rootPath)                             #list the directories under the root path
    for dir in dirs:                                        #traversal all the directories
        path = rootPath + os.sep + dir                      #complete the path of current file
        if os.path.isdir(path):
            findFile(path, fileSeq, delSeq)                 #if current file is a directory, recursive the function
        else:
            md5Check(path, fileSeq, delSeq)                 #if not a directory, check the md5

def md5Check(path, fileSeq, delSeq):
    f = file(path, 'rb')                                    #open the file with 'read-only' and 'binary'
    md5obj = hashlib.md5()
    md5obj.update(f.read())                                 #calculate the md5
    if md5obj.hexdigest() in fileSeq:
        delSeq.append(path)                                 #if md5 of current file is in the fileSeq, put the file path into the delSeq
    else:
        fileSeq.append(md5obj.hexdigest())                  #if not in the fileSeq, put the md5 into the fileSeq
    f.close()                                               #close the file

def delList(delSeq):
    print 'These files are waiting to be removed:'
    for delFile in delSeq:
        print delFile                                       #list the file path in the delSeq

#the main program
fileSeq = []
delSeq = []
while True:
    if len(sys.argv) == 1:
        rootPath = raw_input('Enter the root path: ')       #one parameter means no parameter, ask the root path
    else:
        rootPath = sys.argv[1]                              #or get the second parameter as the root path
    try:
        findFile(rootPath, fileSeq, delSeq)                 #try if the root path is valid
    except(OSError):
        print 'The root path is invalid. Please enter again. '
        del sys.argv[1:]
        continue                                            #catch the except and delete all invalid parameters
    break

if len(delSeq) == 0 :
    print 'No duplicate file was found! '                   #if no files in delSeq, exit
else:
    delList(delSeq)                                         #or list the delSeq
    while True:
        answer = raw_input('Would you want to remove these files? Please answer yes(y) or no(n): ')
        answer.lower
        if answer in ('yes', 'y'):                          #if "yes"
            for delFile in delSeq:
                try:
                    os.remove(delFile)                      #remove all files in delSeq
                except(OSError):
                    print 'Warning! "%s" is not existed! ' % delFile
                    continue                                #ignore the files witch are not existed
            print 'All duplicate files have been removed! '
            break
        elif answer in ('no', 'n'):
            print 'Process has exited without any change! '
            break                                           #if "no", do nothing
        else:
            print 'Please enter yes(y) or no(n). '
sys.exit()                                                  #exit
