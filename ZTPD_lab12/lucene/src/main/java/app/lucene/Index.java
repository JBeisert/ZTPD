package app.lucene;
import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.pl.PolishAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.document.StringField;
import org.apache.lucene.document.TextField;
import org.apache.lucene.index.*;
import org.apache.lucene.store.FSDirectory;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.Scanner;

public class Index {
    public static void main(String[] args) throws IOException {
        String indexPath = "index";
        FSDirectory directory = FSDirectory.open(Paths.get(indexPath));
		
		Analyzer analyzer = new PolishAnalyzer();
		
        IndexWriterConfig config = new IndexWriterConfig(analyzer);
        IndexWriter writer = new IndexWriter(directory, config);

        writer.addDocument(buildDoc("Lucyna w akcji", "9780062316097"));
        writer.addDocument(buildDoc("Akcje rosną i spadają", "9780385545955"));
        writer.addDocument(buildDoc("Bo ponieważ", "9781501168007"));
        writer.addDocument(buildDoc("Naturalnie urodzeni mordercy", "9780316485616"));
        writer.addDocument(buildDoc("Druhna rodzi", "9780593301760"));
        writer.addDocument(buildDoc("Urodzić się na nowo", "9780679777489"));


        Scanner scanner = new Scanner(System.in);
        System.out.print("Czy chcesz dodać do indeksu? [y/n]: ");
        String answer = scanner.nextLine();

        if ("y".equalsIgnoreCase(answer)) {
            System.out.print("title: ");
            String title = scanner.nextLine();
			
            System.out.print("isbn: ");
            String isbn = scanner.nextLine();
			
            writer.addDocument(buildDoc(title, isbn));
			
            System.out.println("Dodano nowy dokument");
        }

        writer.close();
    }

    private static Document buildDoc(String title, String isbn) {
        Document doc = new Document();
		
        doc.add(new TextField("title", title, Field.Store.YES));
        doc.add(new StringField("isbn", isbn, Field.Store.YES));
		
        return doc;
    }
}
