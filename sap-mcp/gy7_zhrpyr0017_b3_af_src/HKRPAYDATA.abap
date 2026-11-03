********************************************************************
* HKRPAYDATA Data definitions for payroll cluster KR South Korea
********************************************************************
* THIS INCLUDE WAS GENERATED
* BY REPORT:___H99UMACROGENERATOR
* USER:________MOOCKW
* ON:__________29.03.2021
* DO NOT CHANGE MANUALLY!!!!!!!!!!!!!!!!!!
********************************************************************
*Payroll Result Korea : Social Insurance
DATA: KRSI TYPE HRPAYKR_SI WITH HEADER LINE.
*-------------
*Payroll Result Korea : Tax
DATA: KRTAX TYPE HRPAYKR_TAX WITH HEADER LINE.
*-------------
*Payroll Results Korea: Separation payroll II (Master Data)
DATA: KRSP1 TYPE HRPAYKR_SP1 WITH HEADER LINE.
*-------------
*Payroll Results Korea: Separation payroll II
DATA: KRSP2 TYPE HRPAYKR_SP2 WITH HEADER LINE.
*-------------
*Payroll result for benefit point request
DATA: BEN_BPS TYPE HRPAY99_BEN_BPS WITH HEADER LINE.
*-------------
*Payroll Result Korea: Retirement Pension Plan
DATA: KRRP TYPE HRPAYKR_RP WITH HEADER LINE.
*-------------
DATA: cumul_tab_filter TYPE PAYKR_RESULT .
DATA: cumul_tab_all TYPE PAYKR_RESULT .
DATA: payresult_addcu TYPE PAYKR_RESULT .