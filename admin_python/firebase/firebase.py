import argparse

import json

import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

class Firebase:
    def __init__(self):
        self.cred = credentials.Certificate("./a18s-app-firebase-adminsdk-cnla7-b223cf7255.json")
        firebase_admin.initialize_app(self.cred)
        self.db = firestore.client()
        self.chart_ref = self.db.collection(u'chart_data')

    def getLastTest(self):
        query = self.chart_ref.order_by(u"`test id`", direction=firestore.Query.DESCENDING).limit(1)
        docs = query.stream()
        for doc in docs:
            print(doc.to_dict())
    
    def getTestId(self, testId):
        query = self.chart_ref.where(u"`test id`", u"==", testId)
        docs = query.stream()
        for doc in docs:
            print(doc.to_dict())

    def setData(self, data):
        jsonData = json.loads(data.replace("'",""))

        testId = int(jsonData["test id"])
        query = self.chart_ref.where(u"`test id`", u"==", testId)
        docs = query.get()

        if len(docs) == 1:
            docs[0].reference.set(jsonData,merge=True)
        elif len(docs) ==0:
            self.chart_ref.document().set(jsonData)


            
# Shell Caller
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Firebase Control')
    parser.add_argument('--test_id', type=int, default=-1)
    parser.add_argument('--set', type=str, default="")

    args = parser.parse_args()

    fb = Firebase()
    if args.test_id != -1:
        if args.test_id == 0:
            fb.getLastTest()
        else:
            fb.getTestId(args.test_id)

    if args.set != "":
        fb.setData("'" + args.set + "'")