package app.lucene;
import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.pl.PolishAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.index.*;
import org.apache.lucene.queryparser.classic.ParseException;
import org.apache.lucene.queryparser.classic.QueryParser;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.ScoreDoc;
import org.apache.lucene.search.TopDocs;
import org.apache.lucene.store.FSDirectory;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.Scanner;

public class Search {
    public static void main(String[] args) throws IOException, ParseException {
        String indexPath = "index";
        Analyzer analyzer = new PolishAnalyzer();

        FSDirectory directory = FSDirectory.open(Paths.get(indexPath));
        IndexReader reader = DirectoryReader.open(directory);
        IndexSearcher searcher = new IndexSearcher(reader);

        Scanner scanner = new Scanner(System.in);
        System.out.print("Query: ");
        String querystr = scanner.nextLine();
        Query query = new QueryParser("title", analyzer).parse(querystr);

        int maxHits = 10;
        TopDocs topDocs = searcher.search(query, maxHits);
        ScoreDoc[] hits = topDocs.scoreDocs;

        System.out.println("Found " + hits.length + " matching docs.");
        for (ScoreDoc scoreDoc : hits) {
            int docId = scoreDoc.doc;
            Document doc = searcher.doc(docId);
            System.out.println(doc.get("isbn") + "\t" + doc.get("title"));
        }

        reader.close();
    }
}
