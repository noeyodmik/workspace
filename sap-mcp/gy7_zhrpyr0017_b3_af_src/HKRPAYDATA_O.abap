********************************************************************
* HKRPAYDATA_O Data definitions for payroll cluster KR South Korea
********************************************************************
* THIS INCLUDE WAS GENERATED
* BY REPORT:___H99UMACROGENERATOR
* USER:________MOOCKW
* ON:__________29.03.2021
* DO NOT CHANGE MANUALLY!!!!!!!!!!!!!!!!!!
********************************************************************
*Payroll Result Korea : Social Insurance
DATA: OKRSI TYPE HRPAYKR_SI WITH HEADER LINE.
*-------------
*Payroll Result Korea : Tax
DATA: OKRTAX TYPE HRPAYKR_TAX WITH HEADER LINE.
*-------------
*Payroll Results Korea: Separation payroll II (Master Data)
DATA: OKRSP1 TYPE HRPAYKR_SP1 WITH HEADER LINE.
*-------------
*Payroll Results Korea: Separation payroll II
DATA: OKRSP2 TYPE HRPAYKR_SP2 WITH HEADER LINE.
*-------------
*Payroll result for benefit point request
DATA: OBEN_BPS TYPE HRPAY99_BEN_BPS WITH HEADER LINE.
*-------------
*Payroll Result Korea: Retirement Pension Plan
DATA: OKRRP TYPE HRPAYKR_RP WITH HEADER LINE.
*-------------
DATA: cumul_tab_filter_o TYPE PAYKR_RESULT .
DATA: cumul_tab_all_o TYPE PAYKR_RESULT .