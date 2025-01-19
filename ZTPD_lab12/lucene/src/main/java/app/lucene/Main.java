package app.lucene;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.en.EnglishAnalyzer;
import org.apache.lucene.analysis.pl.PolishAnalyzer;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.document.StringField;
import org.apache.lucene.document.TextField;
import org.apache.lucene.index.*;
import org.apache.lucene.queryparser.classic.ParseException;
import org.apache.lucene.queryparser.classic.QueryParser;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.ScoreDoc;
import org.apache.lucene.search.TopDocs;
import org.apache.lucene.store.ByteBuffersDirectory;
import org.apache.lucene.store.Directory;

import java.io.IOException;

public class Main {
    public static void main(String[] args) throws IOException, ParseException {
        //StandardAnalyzer analyzer = new StandardAnalyzer();
		
        //Analyzer analyzer = new EnglishAnalyzer();
		
        Analyzer analyzer = new PolishAnalyzer();

        Directory directory = new ByteBuffersDirectory();
        IndexWriterConfig config = new IndexWriterConfig(analyzer);
        IndexWriter w = new IndexWriter(directory, config);

        //w.addDocument(buildDoc("Lucene in Action", "9781473671911"));
        //w.addDocument(buildDoc("Lucene for Dummies", "9780735219090"));
        //w.addDocument(buildDoc("Managing Gigabytes", "9781982131739"));
        //w.addDocument(buildDoc("The Art of Computer Science", "9781250301695"));
        //w.addDocument(buildDoc("Dummy and yummy title", "9780525656161"));

        w.addDocument(buildDoc("Lucyna w akcji", "9780062316097"));
        w.addDocument(buildDoc("Akcje rosną i spadają", "9780385545955"));
        w.addDocument(buildDoc("Bo ponieważ", "9781501168007"));
        w.addDocument(buildDoc("Naturalnie urodzeni mordercy", "9780316485616"));
        w.addDocument(buildDoc("Druhna rodzi", "9780593301760"));
        w.addDocument(buildDoc("Urodzić się na nowo", "9780679777489"));
        w.close();

        //String querystr = "dummy";
        //String querystr = "and";
        //Query q = new QueryParser("title", analyzer).parse(querystr);

        // zad 7a - zwraca "Dummy and yummy title"
        // zad 7b - zwraca "Dummy and yummy title"
        // zad 9  - dla 'dummy' zwraca "Lucene for Dummies" i "Dummy and yummy title", a dla 'and' brak zwracanych

        // Do zadań z analizatorem polskim
        String querystr = "naturalne~1";
        Query q = new QueryParser("title", analyzer).parse(querystr);

        // zad 12a - String querystr = "9780062316097";
        // Wyniki: "Lucyna w akcji"

        // zad 12b - String querystr = "urodzić";
        // Wyniki: "Urodzić się na nowo", "Naturalnie urodzeni mordercy"

        // zad 12c - String querystr = "rodzić";
        // Wyniki: Brak wyników

        // zad 12d - String querystr = "ro*";
        // Wyniki: "Akcje rosną i spadają", "Druhna rodzi"

        // zad 12e - String querystr = "ponieważ";
        // Wyniki: Brak wyników

        // zad 12f - String querystr = "Lucyna AND akcja";
        // Wyniki: "Lucyna w akcji"

        // zad 12g - String querystr = "akcja NOT Lucyna";
        // Wyniki: "Akcje rosną i spadają"

        // zad 12h - String querystr = "\"naturalnie morderca\"~2";
        // Wyniki: "Naturalnie urodzeni mordercy"

        // zad 12i - String querystr = "\"naturalnie morderca\"~1";
        // Wyniki: "Naturalnie urodzeni mordercy"

        // zad 12j - String querystr = "\"naturalnie morderca\"";
        // Wyniki: Brak wyników

        // zad 12k - String querystr = "naturalne";
        // Wyniki: "Naturalnie urodzeni mordercy"

        // zad 12l - String querystr = "title:naturalne~1";
        // Wyniki: "Naturalnie urodzeni mordercy"

        int maxHits = 10;
        IndexReader reader = DirectoryReader.open(directory);
        IndexSearcher searcher = new IndexSearcher(reader);
        TopDocs docs = searcher.search(q, maxHits);
        ScoreDoc[] hits = docs.scoreDocs;

        System.out.println("Found " + hits.length + " matching docs.");
        StoredFields storedFields = searcher.storedFields();
        for(int i=0; i<hits.length; ++i) {
            int docId = hits[i].doc;
            Document d = storedFields.document(docId);
            System.out.println((i + 1) + ". " + d.get("isbn")
                    + "\t" + d.get("title"));
        }

        reader.close();
    }

    private static Document buildDoc(String title, String isbn) {
        Document doc = new Document();
        doc.add(new TextField("title", title, Field.Store.YES));
        doc.add(new StringField("isbn", isbn, Field.Store.YES));
        return doc;
    }
}
