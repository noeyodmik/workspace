********************************************************************
* H99PAYDATA_O Data definitions for payroll cluster RX Other Countries
********************************************************************
* THIS INCLUDE WAS GENERATED
* BY REPORT:___H99UMACROGENERATOR
* USER:________MOOCKW
* ON:__________29.03.2021
* DO NOT CHANGE MANUALLY!!!!!!!!!!!!!!!!!!
********************************************************************
*Statusinformationen der Abrechnung
DATA: OVERSC TYPE PC202 .
*-------------
*Kumulation Abwesenheitsklassen
DATA: OABC TYPE HRPAY99_ABC WITH HEADER LINE.
*-------------
*Abrechnungsergebnis: Ergebnistabelle
DATA: ORT TYPE HRPAY99_RT WITH HEADER LINE.
*-------------
*Abrechnungsergebnis: kumulierte Ergebnistabelle
DATA: OCRT TYPE HRPAY99_CRT WITH HEADER LINE.
*-------------
*Kostenverteilung
DATA: OC0 TYPE HRPAY99_C0 WITH HEADER LINE.
*-------------
*Abrechnungsergebnis: Urlaubsabtragung
DATA: OVCP TYPE HRPAY99_VCP WITH HEADER LINE.
*-------------
*Abrechnungsergebnis: Differenzen für Brutto/Netto
DATA: ODFT TYPE HRPAY99_DFT WITH HEADER LINE.
*-------------
*Abrechnungsergebnis: Ergebnistabelle
DATA: OGRT TYPE HRPAY99_GRT WITH HEADER LINE.
*-------------
*Abrechnungsergebnis: Folgelohnscheine
DATA: OLS TYPE HRPAY99_LS WITH HEADER LINE.
*-------------
*Statuskennzeichen
DATA: OSTATUS TYPE PC20J .
*-------------
*Abrechnungsergebnis: Tabelle Arrears
DATA: OARRRS TYPE HRPAY99_ARRRS WITH HEADER LINE.
*-------------
*Abrechnungsergebnis: Nicht getätigte Abzüge (Deductions)
DATA: ODDNTK TYPE HRPAY99_DDNTK WITH HEADER LINE.
*-------------
*Abrechnungsergebnis: Month End Accruals
DATA: OACCR TYPE HRPAY99_ACCR WITH HEADER LINE.
*-------------
*Abrechnungsstruktur Fundsmanagement
DATA: OFUND TYPE HRPAY99_FUND WITH HEADER LINE.
*-------------
*Eingefrorene Durchschnittswerte im Abrechnungsergebnis
DATA: OAVERAGE TYPE HRPAY99_AVERAGE WITH HEADER LINE.
*-------------
*HR-PAY: Modifikatoren
DATA: OMODIF TYPE HRPAY99_MODIF WITH HEADER LINE.
*-------------
*Abfluss/Zufluss in eine bzw. aus einer Abrechnungsperiode
DATA: OLIFL TYPE HRPAY99_LIFL WITH HEADER LINE.
*-------------
*Kostenverteilte Verbindlichkeiten
DATA: OLIDI TYPE HRPAY99_LIDI WITH HEADER LINE.
*-------------
*Variable Zuordnung
DATA: OV0 TYPE HRPAY99_V0 WITH HEADER LINE.
*-------------
*Benefits Abrechnungsergebnis International
DATA: OBENTAB TYPE HRPAY99_BENTAB WITH HEADER LINE.
*-------------
*Verteilung von Verbindlichkeiten
DATA: OCODIST TYPE HRPAY99_CODIST WITH HEADER LINE.
*-------------