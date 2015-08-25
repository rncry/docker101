#!/usr/bin/python

import sys
from PyQt4 import QtGui

if __name__ == '__main__':

    app = QtGui.QApplication(sys.argv)

    thing = QtGui.QMessageBox()
    thing.setText("Hello I'm production code!")
    thing.exec_()
