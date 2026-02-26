package com.library.model;

import java.time.LocalDateTime;

public class Book {

    private int           bookId;
    private String        title;
    private String        author;
    private Integer       yearPub;
    private String        genre;
    private String        coverUrl;
    private String        readUrl;
    private String        pdfUrl;
    private String        epubUrl;
    private String        source;
    private String        description;
    private LocalDateTime addedDate;

    public Book() {}

    // ── Getters & Setters ─────────────────────────────────────────────────────

    public int    getBookId()              { return bookId; }
    public void   setBookId(int v)         { this.bookId = v; }

    public String getTitle()              { return title; }
    public void   setTitle(String v)      { this.title = v; }

    public String getAuthor()             { return author; }
    public void   setAuthor(String v)     { this.author = v; }

    public Integer getYearPub()           { return yearPub; }
    public void    setYearPub(Integer v)  { this.yearPub = v; }

    public String getGenre()              { return genre; }
    public void   setGenre(String v)      { this.genre = v; }

    public String getCoverUrl()           { return coverUrl; }
    public void   setCoverUrl(String v)   { this.coverUrl = v; }

    public String getReadUrl()            { return readUrl; }
    public void   setReadUrl(String v)    { this.readUrl = v; }

    public String getPdfUrl()             { return pdfUrl; }
    public void   setPdfUrl(String v)     { this.pdfUrl = v; }

    public String getEpubUrl()            { return epubUrl; }
    public void   setEpubUrl(String v)    { this.epubUrl = v; }

    public String getSource()             { return source; }
    public void   setSource(String v)     { this.source = v; }

    public String getDescription()        { return description; }
    public void   setDescription(String v){ this.description = v; }

    public LocalDateTime getAddedDate()          { return addedDate; }
    public void          setAddedDate(LocalDateTime v){ this.addedDate = v; }

    /** Convenience: serialise to a simple JSON string (no extra library needed). */
    public String toJson() {
        return "{"
            + "\"bookId\":"     + bookId                          + ","
            + "\"title\":"      + jsonStr(title)                  + ","
            + "\"author\":"     + jsonStr(author)                 + ","
            + "\"yearPub\":"    + (yearPub != null ? yearPub : "null") + ","
            + "\"genre\":"      + jsonStr(genre)                  + ","
            + "\"coverUrl\":"   + jsonStr(coverUrl)               + ","
            + "\"readUrl\":"    + jsonStr(readUrl)                + ","
            + "\"pdfUrl\":"     + jsonStr(pdfUrl)                 + ","
            + "\"epubUrl\":"    + jsonStr(epubUrl)                + ","
            + "\"source\":"     + jsonStr(source)                 + ","
            + "\"description\":" + jsonStr(description)
            + "}";
    }

    private static String jsonStr(String s) {
        if (s == null) return "null";
        return "\"" + s.replace("\\", "\\\\").replace("\"", "\\\"")
                        .replace("\n", "\\n").replace("\r", "") + "\"";
    }
}
