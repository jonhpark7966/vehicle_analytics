import sys
import argparse

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

            
# Shell Caller
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Firebase Control')
    parser.add_argument('--test_id', type=int, default=0)

    args = parser.parse_args()

    fb = Firebase()
    if args.test_id == 0:
        fb.getLastTest()
    else:
        fb.getTestId(args.test_id)