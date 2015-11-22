# setwd("D:\\cursuri\\CKME136_CapstoneProject\\enron_dataset\\maildir")

library(dplyr);
library(knitr);
library(NLP);
library(tm);
library(tau);
library(slam);
library(RColorBrewer);
library(wordcloud);
library(SnowballC);
library(igraph);

Sys.time();

base_dir <- "D:\\cursuri\\CKME136_CapstoneProject\\enron_dataset\\maildir";
setwd(base_dir);
email_name_list <- list.dirs(full.names=FALSE, recursive=FALSE);

email_map <- vector();

for (d in email_name_list) {
  current_email_name <- d;
  base_email_dir <- paste(base_dir,"\\",d, sep = "");
  sent_dir <- dir(path = base_email_dir, pattern = "sent");
  for (s in sent_dir) {
    current_dir <- paste(base_dir, "\\", d, "\\", s, sep = "");
    setwd(current_dir);
    email_files <- list.files(path = current_dir);
    for (f in email_files) {
      file_handler <- file(f, "rb");
      f_lines <- readLines(file_handler, n = 5, encoding = "UTF-8", skipNul = TRUE);
      from_line <- f_lines[grepl('From',f_lines)];
      from_address <- unlist(strsplit(from_line, ":"))[2];
      from_address <- gsub("\\s+", "", from_address);
      if ( is.na(email_map[from_address]) ) {
        email_map[from_address] <- current_email_name;
      }  
      close(file_handler);
    }  
  }
}

Sys.time();


email_stats <- matrix(0, length(email_name_list), length(email_name_list));
colnames(email_stats) <- c(email_name_list);
rownames(email_stats) <- c(email_name_list);

# read the receivers e-mails and update the email_stats matrix
for (d in email_name_list) {
  current_email_name <- d;
  base_email_dir <- paste(base_dir,"\\",d, sep = "");
  sent_dir <- dir(path = base_email_dir, pattern = "sent");
  for (s in sent_dir) {
    current_dir <- paste(base_dir, "\\", d, "\\", s, sep = "");
    setwd(current_dir);
    email_files <- list.files(path = current_dir);
    for (f in email_files) {
      file_handler <- file(f, "rb");
      f_lines <- readLines(file_handler, warn = FALSE, encoding = "UTF-8", skipNul = TRUE);
      process_rec <- FALSE;
      for (l in f_lines) {
        to_l <- grep("^to|^cc|^bcc", l, ignore.case =TRUE);
        if ( length(grep("^to|^cc|^bcc", l, ignore.case =TRUE)) ) {
          process_rec <- TRUE;
          receiver_addr <- unlist(strsplit(l, ":"))[2];
        }
        else {
          if ( length(grep("^X", l, ignore.case = TRUE)) ) {
            break;
          }
          else {
            if ( length(grep(":", l)) ) {
              process_rec <- FALSE;
              next;
            }
            else {
              process_rec <- TRUE;
              receiver_addr <- l;
            }
          }
        }
        if ( process_rec == TRUE ) {
            receiver_addr <- gsub("\\s+", "", receiver_addr);
            addr_vec <- unlist(strsplit(receiver_addr, ","));
            for ( a in addr_vec) {
              addr_name <- email_map[a];
              if ( ! is.na(addr_name) ) {
                email_stats[current_email_name,addr_name] <- email_stats[current_email_name,addr_name] + 1;
              }
            }
        }
      }
      
      close(file_handler);
    }  
  }
}


# use igraph to display the emails network
ig <- graph.adjacency(email_stats, mode="directed", weighted=TRUE);

#raw plot
ig <- graph.adjacency(email_stats, mode="directed", weighted=TRUE)
plot(ig);

# delete loops
g <- simplify(ig);
plot(g);

# plot for large network
# http://michael.hahsler.net/SMU/LearnROnYourOwn/code/igraph.html
layout <- layout.fruchterman.reingold(g)
plot(g, layout=layout, vertex.size=2, vertex.label=NA, edge.arrow.size=.2)


# plot only vertices with more than 40 edges
low.vs <- V(g)[degree(g) < 40];   #identify those vertices part of less than three edges
gr <- delete.vertices(g, low.vs); #exclude them from the graph
plot(gr);



# plot comunities
wc <- walktrap.community(g);
plot(wc, g);


# extract main group and display the most important people in the group
# link: http://orbifold.net/R/iGraph/
V(g)$label.cex = .15;
x <- which.max(sizes(wc));
largestGroup = induced.subgraph(g, which(membership(wc) == x));
V(largestGroup)$label.cex = 0.5;
plot(largestGroup, vertex.size=betweenness(largestGroup)/17);


sizes(wc);

subgroup <- 1;
grp = induced.subgraph(g, which(membership(wc) == subgroup));
V(grp)$label.cex = 1;
plot(grp, vertex.size=betweenness(grp));


subgroup <- 5;
grp = induced.subgraph(g, which(membership(wc) == subgroup));
V(grp)$label.cex = 1;
plot(grp, vertex.size=betweenness(grp)/4);


