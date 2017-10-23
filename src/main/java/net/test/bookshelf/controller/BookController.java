package net.test.bookshelf.controller;

import net.test.bookshelf.model.Book;
import net.test.bookshelf.service.BookService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.support.PagedListHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@Controller
public class BookController {
    private BookService bookService;
    private static final int MAX_ROWS_PER_PAGE = 10;

    @Autowired(required = true)
    @Qualifier(value = "bookService")
    public void setBookService(BookService bookService) {
        this.bookService = bookService;
    }


    @RequestMapping(value = "books", method = RequestMethod.GET)
    public String pages(Model model, @RequestParam(required = false) Integer page, @RequestParam(required = false) String title) {
        model.addAttribute("book", new Book());
        if (title == null) title = "";

        List<Book> books = this.bookService.listBooks();
        ArrayList<Book> result = new ArrayList<>();
        for (Book book: books) {
            if (null != book.getTitle() && book.getTitle().contains(title))
                result.add(book);
        }

        PagedListHolder<Book> pagedListHolder = new PagedListHolder<>(result);
        pagedListHolder.setPageSize(MAX_ROWS_PER_PAGE);
        model.addAttribute("maxPages", pagedListHolder.getPageCount());

        if (page == null || page < 1 || page > pagedListHolder.getPageCount()) {
            page = 1;
        }
        model.addAttribute("page", page);
        if (page == null || page < 1 || page > pagedListHolder.getPageCount()) {
            pagedListHolder.setPage(0);
            model.addAttribute("listBooks", pagedListHolder.getPageList());
        } else if (page <= pagedListHolder.getPageCount()) {
            pagedListHolder.setPage(page - 1);
            model.addAttribute("listBooks", pagedListHolder.getPageList());
        }
        return "books";
    }

    @RequestMapping(value = "/books/add", method = RequestMethod.POST)
    public String addBook(@ModelAttribute("book") Book book){
        if(book.getId() == 0){
            this.bookService.addBook(book);
        }else {
            this.bookService.updateBook(book);
        }
        return "redirect:/books";
    }

    @RequestMapping("/remove/{id}")
    public String removeBook(@PathVariable("id") int id){
        this.bookService.removeBook(id);
        return "redirect:/books";
    }

    @RequestMapping(value = "edit/{id}", method = RequestMethod.GET)
    public String editBookGet(@PathVariable("id") int id, Model model){
        model.addAttribute("book", this.bookService.getBookById(id));
        return "edit";
    }

    @RequestMapping(value = "edit/{id}", method = RequestMethod.POST)
    public String editBookPost(@ModelAttribute("book") Book book, int id){
        book.setReadAlready(false);
        this.bookService.updateBook(book);
        return "redirect:/books";
    }

    @RequestMapping("bookdata/{id}")
    public String bookData(@PathVariable("id") int id, Model model){
        model.addAttribute("book", this.bookService.getBookById(id));
        return "bookdata";
    }

    @RequestMapping("/read/{id}")
    public String readBook(@PathVariable("id") int id){
        this.bookService.readBook(id);
        return "redirect:/books";
    }

}
