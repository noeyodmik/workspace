import io
import sys
import config
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

params = {
    'ashost': 'vacigy7',
    'sysnr': '00',
    'client': '100',
    'user': 'seppin',
    'passwd': 'Qwer1234@',
    'lang': 'KO',
    'saprouter': '/H/10.20.13.11/S/3299/H/payroll50.sapsf.eu/S/3299'
}

try:
    print('Connecting to GY7 (Client 100)...')
    c = Connection(**params)
    res = c.call('RFC_PING')
    print('RFC_PING to GY7 successful!')
    info = c.call('RFC_SYSTEM_INFO')
    si = info.get('RFCSI_EXPORT', {})
    print('System Info:', si.get('RFCSYSID'), si.get('RFCHOST'), si.get('RFCDBSYS'), si.get('RFCSAPRL'))
except Exception as e:
    print('Connection error:', e)
