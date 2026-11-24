package edu.group05.library;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class LibraryController {
    private final LibraryService library;
    public LibraryController(LibraryService library) { this.library = library; }

    @GetMapping("/")
    public String dashboard(Model model) {
        model.addAttribute("page", "Dashboard");
        model.addAttribute("books", library.books(""));
        model.addAttribute("loans", library.loans());
        model.addAttribute("available", library.availableCount());
        model.addAttribute("overdue", library.loans().stream().filter(l -> "Overdue".equals(l.status())).count());
        return "dashboard";
    }
    @GetMapping("/books")
    public String books(@RequestParam(defaultValue = "") String q, Model model) {
        model.addAttribute("page", "Book search");
        model.addAttribute("q", q);
        model.addAttribute("books", library.books(q));
        return "books";
    }
    @PostMapping("/borrow")
    public String borrow(@RequestParam long bookId, RedirectAttributes redirect) {
        boolean ok = library.borrow(bookId, "Emma Wilson", "R-10482");
        redirect.addFlashAttribute("message", ok ? "Loan created successfully" : "No copies available");
        return "redirect:/";
    }
    @PostMapping("/return")
    public String returnBook(RedirectAttributes redirect) {
        boolean ok = library.returnFirstLoan();
        redirect.addFlashAttribute("message", ok ? "Return confirmed" : "No active loans");
        return "redirect:/";
    }
}
