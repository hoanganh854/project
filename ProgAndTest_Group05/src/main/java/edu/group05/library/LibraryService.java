package edu.group05.library;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicLong;
import org.springframework.stereotype.Service;

@Service
public class LibraryService {
    public record Book(long id, String title, String author, String category,
                       int year, int copies, int available, String shelf) { }
    public record Loan(long id, String book, String reader, String card, String due,
                       String status) { }
    private final List<Book> books = new ArrayList<>();
    private final List<Loan> loans = new ArrayList<>();
    private final AtomicLong ids = new AtomicLong(10);

    public LibraryService() {
        books.add(new Book(1, "The Midnight Library", "Matt Haig", "Fiction", 2020, 4, 0, "FIC-A3"));
        books.add(new Book(2, "Atomic Habits", "James Clear", "Self-help", 2018, 5, 2, "SH-C1"));
        books.add(new Book(3, "Sapiens", "Yuval Noah Harari", "History", 2015, 3, 1, "HIS-D2"));
        books.add(new Book(4, "Educated", "Tara Westover", "Biography", 2018, 3, 2, "BIO-B2"));
        loans.add(new Loan(1, "The Midnight Library", "Emma Wilson", "R-10482", "26 Oct 2026", "Overdue"));
        loans.add(new Loan(2, "Atomic Habits", "Emma Wilson", "R-10482", "6 Nov 2026", "On loan"));
    }

    public synchronized List<Book> books(String query) {
        String q = query == null ? "" : query.trim().toLowerCase();
        return books.stream().filter(b -> (b.title() + " " + b.author() + " " + b.category())
                .toLowerCase().contains(q)).toList();
    }
    public synchronized List<Loan> loans() { return List.copyOf(loans); }
    public synchronized long availableCount() { return books.stream().mapToLong(Book::available).sum(); }
    public synchronized boolean borrow(long bookId, String reader, String card) {
        for (int i = 0; i < books.size(); i++) {
            Book b = books.get(i);
            if (b.id() == bookId && b.available() > 0) {
                books.set(i, new Book(b.id(), b.title(), b.author(), b.category(), b.year(),
                        b.copies(), b.available() - 1, b.shelf()));
                loans.add(0, new Loan(ids.incrementAndGet(), b.title(), reader, card,
                        "8 Dec 2026", "On loan"));
                return true;
            }
        }
        return false;
    }
    public synchronized boolean returnFirstLoan() {
        if (loans.isEmpty()) return false;
        Loan loan = loans.remove(0);
        for (int i = 0; i < books.size(); i++) {
            Book b = books.get(i);
            if (b.title().equals(loan.book())) {
                books.set(i, new Book(b.id(), b.title(), b.author(), b.category(), b.year(),
                        b.copies(), Math.min(b.copies(), b.available() + 1), b.shelf()));
                return true;
            }
        }
        return true;
    }
}
