(: Zapytanie 1
for $pracownik in doc('file:///C:/Studia/ztpd/ZTPD_lab8_9/XPATHXSLT/XPATHXSLT/zesp_prac.xml')
    /ZESPOLY/ROW/PRACOWNICY/ROW
return <NAZWISKO>
{$pracownik/NAZWISKO/text()}
</NAZWISKO>
:)

(: Zapytanie 2
for $zesp in doc('file:///C:/Studia/ztpd/ZTPD_lab8_9/XPATHXSLT/XPATHXSLT/zesp_prac.xml')
    /ZESPOLY/ROW
where $zesp/NAZWA = "SYSTEMY EKSPERCKIE"
return
    for $pracownik in $zesp/PRACOWNICY/ROW
    return <NAZWISKO>{$pracownik/NAZWISKO/text()}</NAZWISKO>
:)

(: Zapytanie 3
let $zesp := doc('file:///C:/Studia/ztpd/ZTPD_lab8_9/XPATHXSLT/XPATHXSLT/zesp_prac.xml')
    /ZESPOLY/ROW[ID_ZESP = 10]
return count($zesp/PRACOWNICY/ROW)
:)

(: Zapytanie 4
for $pracownik in doc('file:///C:/Studia/ztpd/ZTPD_lab8_9/XPATHXSLT/XPATHXSLT/zesp_prac.xml')
    /ZESPOLY/ROW/PRACOWNICY/ROW[ID_SZEFA = 100]
return <NAZWISKO>
{$pracownik/NAZWISKO/text()}
</NAZWISKO>
:)

let $brzezinski := doc('file:///C:/Studia/ztpd/ZTPD_lab8_9/XPATHXSLT/XPATHXSLT/zesp_prac.xml')
    /ZESPOLY/ROW/PRACOWNICY/ROW[NAZWISKO = "BRZEZINSKI"]
let $zesp := $brzezinski/ancestor::ROW
return sum($zesp/PRACOWNICY/ROW/PLACA_POD)
