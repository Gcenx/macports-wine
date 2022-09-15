import os
import signal
import sys
import traceback

from Foundation import NSObject
import PyObjCTools.KeyValueCoding

import cxlog

# There's a bug in PyObjCTools.Debugging.nsLogPythonException.  It invokes
# NSLog with a first argument which isn't a format string, but is an arbitrary
# string to be logged.  This string may contain percent ('%') characters, which
# will get interpreted as format specifiers.  This will result in an exception
# during exception handling, which is bad.
#
# This is a re-implementation with the only change being that it specifies a
# proper format string.
def _cxLogPythonException(exception):
    userInfo = exception.userInfo()
    NSLog(u'%@', u'*** Python exception discarded!\n' +
                    ''.join(traceback.format_exception(
                        userInfo[u'__pyobjc_exc_type__'],
                        userInfo[u'__pyobjc_exc_value__'],
                        userInfo[u'__pyobjc_exc_traceback__']
                        )).decode('utf8'))
    # we logged it, so don't log it for us
    return False

if cxlog.is_on() or 'DEBUG' in os.environ:
    import PyObjCTools.Debugging
    PyObjCTools.Debugging.nsLogPythonException = _cxLogPythonException
    PyObjCTools.Debugging.installPythonExceptionHandler()


def dump_stacks(sig, frame):
    for tid, tframe in sys._current_frames().iteritems():
        stack = traceback.format_stack(tframe)
        if len(stack) > 0:
            NSLog(u"Thread %@:", tid)
            for line in stack:
                NSLog(u'%@', line)

signal.signal(signal.SIGINFO, dump_stacks)
