#!/opt/collabnet/teamforge//runtime/bin/wrapper/python

import app.util
import getopt
import sys

sys.path.append('/var/ops/monitor/utils')

from ctfdb import ctfdb

def executeQuery(db, sql):
    rows = None
    try:
        rows = db.executeQuery(sql)
    except:
        print "Query failed : %s" % sql
    return rows

def get_stored_message_queue(db):
    sql = """
SELECT
  queue,
  count(1) as count
FROM
  stored_message
where
  queue not like '%gnored%'
group by
  queue;
"""
    #print sql
    rows = executeQuery(db, sql)
    _rows = []
    qnames = ['EventQueue', 'Event2Queue', 'SearchQueue'];
    for qn in qnames:
        count = 0
        for row in rows:
            if row[0] == qn :
                count = row[1]
        _rows.append((qn, count))
    return _rows

def printrows(rows, host, key):
    for row in rows:
        print "cust." + host + "." + key + "." + str(row[0]) + " " + str(row[1]) 

def main():
    host = sys.argv[1]
    cfg = app.util.getRuntimeConfiguration()
    db = ctfdb(cfg)

    rows = get_stored_message_queue(db)
    printrows(rows, host, "custom.eventqueue")

if __name__ == '__main__':
    main()

