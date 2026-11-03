********************************************************************
* H99PAYDATA Data definitions for payroll cluster RX Other Countries
********************************************************************
* THIS INCLUDE WAS GENERATED
* BY REPORT:___H99UMACROGENERATOR
* USER:________MOOCKW
* ON:__________29.03.2021
* DO NOT CHANGE MANUALLY!!!!!!!!!!!!!!!!!!
********************************************************************
*Statusinformationen der Abrechnung
DATA: VERSC TYPE PC202 .
*-------------
*Kumulation Abwesenheitsklassen
DATA: ABC TYPE HRPAY99_ABC WITH HEADER LINE.
*-------------
*Abrechnungsergebnis: Ergebnistabelle
DATA: RT TYPE HRPAY99_RT WITH HEADER LINE.
*-------------
*Abrechnungsergebnis: kumulierte Ergebnistabelle
DATA: CRT TYPE HRPAY99_CRT WITH HEADER LINE.
*-------------
*Kostenverteilung
DATA: C0 TYPE HRPAY99_C0 WITH HEADER LINE.
*-------------
*Abrechnungsergebnis: Urlaubsabtragung
DATA: VCP TYPE HRPAY99_VCP WITH HEADER LINE.
*-------------
*Abrechnungsergebnis: Differenzen für Brutto/Netto
DATA: DFT TYPE HRPAY99_DFT WITH HEADER LINE.
*-------------
*Abrechnungsergebnis: Ergebnistabelle
DATA: GRT TYPE HRPAY99_GRT WITH HEADER LINE.
*-------------
*Abrechnungsergebnis: Folgelohnscheine
DATA: LS TYPE HRPAY99_LS WITH HEADER LINE.
*-------------
*Statuskennzeichen
DATA: STATUS TYPE PC20J .
*-------------
*Abrechnungsergebnis: Tabelle Arrears
DATA: ARRRS TYPE HRPAY99_ARRRS WITH HEADER LINE.
*-------------
*Abrechnungsergebnis: Nicht getätigte Abzüge (Deductions)
DATA: DDNTK TYPE HRPAY99_DDNTK WITH HEADER LINE.
*-------------
*Abrechnungsergebnis: Month End Accruals
DATA: ACCR TYPE HRPAY99_ACCR WITH HEADER LINE.
*-------------
*Abrechnungsstruktur Fundsmanagement
DATA: FUND TYPE HRPAY99_FUND WITH HEADER LINE.
*-------------
*Eingefrorene Durchschnittswerte im Abrechnungsergebnis
DATA: AVERAGE TYPE HRPAY99_AVERAGE WITH HEADER LINE.
*-------------
*HR-PAY: Modifikatoren
DATA: MODIF TYPE HRPAY99_MODIF WITH HEADER LINE.
*-------------
*Abfluss/Zufluss in eine bzw. aus einer Abrechnungsperiode
DATA: LIFL TYPE HRPAY99_LIFL WITH HEADER LINE.
*-------------
*Kostenverteilte Verbindlichkeiten
DATA: LIDI TYPE HRPAY99_LIDI WITH HEADER LINE.
*-------------
*Variable Zuordnung
DATA: V0 TYPE HRPAY99_V0 WITH HEADER LINE.
*-------------
*Benefits Abrechnungsergebnis International
DATA: BENTAB TYPE HRPAY99_BENTAB WITH HEADER LINE.
*-------------
*Verteilung von Verbindlichkeiten
DATA: CODIST TYPE HRPAY99_CODIST WITH HEADER LINE.
*-------------