#!/opt/collabnet/teamforge/runtime/bin/wrapper/python
## #! automatically transformed for use in CollabNet.  The original line was:
## #!/usr/bin/env python
## Add 4 lines of blank or empty comments to maintain line numbers below this
## -- END MODIFIED SECTION --

import sys
import app.util


class ctfdb:

    def __init__(self, cfg):
        if cfg['DATABASE_TYPE'] != None and (cfg['DATABASE_TYPE'] == 'postgresql' or cfg['DATABASE_TYPE'] == 'oracle'):
            self.dbType = cfg['DATABASE_TYPE']
        else:
            self.dbType = 'postgresql'
        self.cfg = cfg
        self._createConnection()

    def _getHost(self):
        for k, v in self.cfg.items():
            if k.find('HOST_') != -1:
                if v.find('database') != -1:
                    return k[5:]

    def _createConnection(self):
        print "[INFO] Database Type: " + self.dbType
        print "[INFO] Database Name: " + self.cfg['DATABASE_NAME']
        import socket,platform,subprocess
        host = self._getHost()
        if host == None:
            host = socket.gethostname()
        try:
            port = self.cfg['DATABASE_PORT']
        except KeyError:
            port = None
        if self.dbType == 'postgresql':
            try:
                import pgdb
            except ImportError, err:
                print "[WARN] ImportError %s" % err
                print "[INFO] Trying to install the package postgresql-python..."
                input = raw_input("Proceed [y/n]? ")
                if input != 'y':
                    print "[INFO] Exiting..."
                    sys.exit(0)
                dist, version, name = platform.dist()
                if dist == 'redhat':
                    p=subprocess.call(['yum','-y','install','postgresql90-python'])
                elif dist =='SuSE':
                    p=subprocess.call(['zypper','-y','install','PyGreSQL'])

            import pgdb
            if port == None:
                port = '5432'
            print '[INFO] Database Host: ' + host + ':' + port
            self.con = pgdb.connect(user = self.cfg['DATABASE_USERNAME'],
                       password = self.cfg['DATABASE_PASSWORD'],
                       database = self.cfg['DATABASE_NAME'],
                       host = host + ':' + port)

        elif self.dbType == 'oracle':
            import cx_Oracle
            if port == None:
                port = '1521'
            print '[INFO] Database Host: ' + host + ':' + port
            dsn = cx_Oracle.makedsn(host, port, self.cfg['DATABASE_NAME'])
            self.con = cx_Oracle.connect(u"%s/%s@%s" % (self.cfg['DATABASE_USERNAME'],
                       self.cfg['DATABASE_PASSWORD'], dsn))


    def dmlQuery(self, stmt):
        cur = self.con.cursor()
        try:
            cur.execute(stmt)
            cur.close()
        except Exception, err:
            self.con.rollback()
            raise DBError("Error when running %s: %s" %(stmt, err))

    def executeQuery(self, stmt):
        cur = self.con.cursor()
        if self.dbType == 'oracle':
           stmt = u"%s" % stmt
        try:
            cur.execute(stmt)
        except Exception, err:
            raise DBError("Error when running %s: %s" %(stmt, err))
        recs = cur.fetchall()
        cur.close()
        return recs

    def commit(self):
        if self.con:
            self.con.commit()

    def rollback(self):
        if self.con:
            self.con.rollback()


class DBError(Exception):

    def __init__(self,error):
        self.error = error

    def getError(self):
        return self.error

    def __str__(self):
        return self.error
