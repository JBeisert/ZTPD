(: Zadanie 5 :)
for $author in doc("db/bib/bib.xml")//author/last
return $author

(: Zadanie 6 :)
for $book in doc("db/bib/bib.xml")//book
for $title in $book/title
for $author in $book/author
return 
  <ksiazka>
    <author>
      <last>{ $author/last/text() }</last>
      <first>{ $author/first/text() }</first>
    </author>
    <title>{ $title/text() }</title>
  </ksiazka>

(: Zadanie 7 :)
for $book in doc("db/bib/bib.xml")//book
for $title in $book/title
for $author in $book/author
return 
  <ksiazka>
    <autor>{ concat($author/last/text(), $author/first/text()) }</autor>
    <tytul>{ $title/text() }</tytul>
  </ksiazka>

(: Zadanie 8 :)
for $book in doc("db/bib/bib.xml")//book
for $title in $book/title
for $author in $book/author
return 
  <ksiazka>
    <autor>{ concat($author/last/text(), " ", $author/first/text()) }</autor>
    <tytul>{ $title/text() }</tytul>
  </ksiazka>

(: Zadanie 9 :)
<wynik>
{
  for $book in doc("db/bib/bib.xml")//book
  for $title in $book/title
  for $author in $book/author
  return 
    <ksiazka>
      <autor>{ concat($author/last/text(), " ", $author/first/text()) }</autor>
      <tytul>{ $title/text() }</tytul>
    </ksiazka>
}
</wynik>

(: Zadanie 10 :)
<imiona>
{
  for $book in doc("db/bib/bib.xml")//book
  where $book/title = "Data on the Web"
  for $author in $book/author
  return <imie>{ $author/first/text() }</imie>
}
</imiona>

(: Zadanie 11.1 :)
<DataOnTheWeb>
{
  doc("db/bib/bib.xml")//book[title = "Data on the Web"]
}
</DataOnTheWeb>

(: Zadanie 11.2 :)
<DataOnTheWeb>
{
  for $book in doc("db/bib/bib.xml")//book
  where $book/title = "Data on the Web"
  return $book
}
</DataOnTheWeb>

(: Zadanie 12 :)
<Data>
{
  for $book in doc("db/bib/bib.xml")//book
  where contains($book/title, "Data")
  for $author in $book/author
  return <nazwisko>{ $author/last/text() }</nazwisko>
}
</Data>

(: Zadanie 13 :)
<Data>
{
    for $book in doc("db/bib/bib.xml")//book,
        $title in $book/title
    where contains($title, 'Data')
    return <title>{$title/text()}</title>
}
{  
    for $book in doc("db/bib/bib.xml")//book
    where contains($book/title, "Data")
    for $author in $book/author
    return <nazwisko>{ $author/last/text() }</nazwisko>
}
</Data>

(: Zadanie 14 :)
for $book in doc("db/bib/bib.xml")//book
let $authorCount := count($book/author)
where $authorCount <= 2
return <title>{ $book/title/text() }</title>

(: Zadanie 15 :)
for $book in doc("db/bib/bib.xml")//book
return
<ksiazka>
  <title>{$book/title/text()}</title>
  <autorow>{count($book/author)}</autorow>
</ksiazka>

(: Zadanie 16 :)
let $years := doc("db/bib/bib.xml")//book/@year
let $minYear := min($years)
let $maxYear := max($years)
return concat($minYear, " - ", $maxYear)

(: Zadanie 17 :)
<różnica>
{
  let $prices := doc("db/bib/bib.xml")//book/price
  let $minPrice := min($prices)
  let $maxPrice := max($prices)
  return $maxPrice - $minPrice
}
</różnica>

(: Zadanie 18 :)
<najtańsze>
{
  let $minPrice := min(doc("db/bib/bib.xml")//book/price/xs:decimal(.))
  for $book in doc("db/bib/bib.xml")//book
  where xs:decimal($book/price) = $minPrice
  return
    <najtańsza>
      <title>{ $book/title/text() }</title>
      {
        for $author in $book/author
        return
          <author><last>{ $author/last/text() }</last><first>{ $author/first/text() }</first></author>
      }
    </najtańsza>
}
</najtańsze>

(: Zadanie 19 :)
<autorzy>
{
  for $author in distinct-values(doc("db/bib/bib.xml")//book/author/last)
  let $books := doc("db/bib/bib.xml")//book[author/last = $author]
  return
    <autor>
      <last>{ $author }</last>
      {
        for $book in $books
        return <title>{ $book/title/text() }</title>
      }
    </autor>
}
</autorzy>

(: Zadanie 20 :)
<wynik>
{
  for $play in collection("db/shakespeare")//PLAY
  return
    <TITLE>{ $play/TITLE/text() }</TITLE>
}
</wynik>

(: Zadanie 21 :)
for $play in collection("db/shakespeare")/PLAY,
    $line in $play//LINE
where contains($line, "or not to be")
return $play/TITLE

(: Zadanie 22 :)
<wynik>
{
  for $play in collection("db/shakespeare")//PLAY
  let $characters := $play//PERSONA
  let $acts := $play//ACT
  let $scenes := $play//SCENE
  return
    <sztuka tytul="{ $play/TITLE/text() }">
      <postaci>{ count($characters) }</postaci>
      <aktow>{ count($acts) }</aktow>
      <scen>{ count($scenes) }</scen>
    </sztuka>
}
</wynik>
