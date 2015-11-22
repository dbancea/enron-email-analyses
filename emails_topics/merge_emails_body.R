
library(dplyr);
library(knitr);
library(NLP);
library(tm);
library(tau);
library(slam);
library(RColorBrewer);
library(wordcloud);
library(SnowballC);

Sys.time();

base_dir <- "D:\\cursuri\\CKME136_CapstoneProject\\enron_dataset\\maildir";
setwd(base_dir);
email_name_list <- list.dirs(full.names=FALSE, recursive=FALSE);

# read the receivers e-mails and add the email body to the tm corpus
tmp_base_dir <- "D:\\cursuri\\CKME136_CapstoneProject\\enron_dataset\\tmp";
for (d in email_name_list) {
  current_email_name <- d;
  base_email_dir <- paste(base_dir,"\\",d, sep = "");
  sent_dir <- dir(path = base_email_dir, pattern = "sent");
  email_body <- vector();
  for (s in sent_dir) {
    current_dir <- paste(base_dir, "\\", d, "\\", s, sep = "");
    setwd(current_dir);
    email_files <- list.files(path = current_dir);
    for (f in email_files) {
      file_handler <- file(f, "rb");
      f_lines <- readLines(file_handler, warn = FALSE, encoding = "UTF-8", skipNul = TRUE);
      f_subject <- f_lines[ 1:grep("^X-FileName:", f_lines) ];
      f_subject <- f_subject[ grep("Subject:", f_subject) ];
      f_subject <- gsub("subject|:|re","",f_subject, ignore.case = TRUE);
      email_body <- append(email_body,f_subject);
      f_lines <- f_lines[ -1:- grep("^X-FileName:", f_lines) ];
      for (l in f_lines) {
        if ( length(grep("Original Message", l, ignore.case =TRUE)) ) {
          break;
        }
        else {
          if ( length(grep("@|forwarded|from|subject|cc:|---", l, ignore.case =TRUE)) ) {
            next;
          }
          else {
            email_body <- append(email_body,l);  
          }
        }
      }
      close(file_handler);
    }  
  }
  email_body_file <- paste(tmp_base_dir,"\\",d,".txt", sep = "");
  write(email_body,email_body_file, sep="\n")
}
