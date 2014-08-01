WickedPdf.config = {
  :wkhtmltopdf => '/usr/bin/wkhtmltopdf',
  #:layout => "pdf.html",
  :exe_path => '/usr/bin/wkhtmltopdf',
  :header => {:html => {:template => "layouts/pdf/_header.html"}},
  :footer => {:html => {:template => "layouts/pdf/_footer.html"}}
}
