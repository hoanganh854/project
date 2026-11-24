package edu.group05.library;

import static org.junit.jupiter.api.Assertions.assertTrue;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class LibraryServiceTest {
    @Autowired private LibraryService library;
    @Test void seededCatalogHasBooks() { assertTrue(library.books("").size() >= 4); }
    @Test void searchMatchesBookTitle() { assertTrue(library.books("Atomic").stream().anyMatch(b -> b.title().equals("Atomic Habits"))); }
}
