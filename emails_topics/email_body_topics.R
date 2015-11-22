
library(dplyr);
library(knitr);
library(NLP);
library(tm);
library(tau);
library(slam);
library(RColorBrewer);
library(wordcloud);
library(SnowballC);
library(topicmodels);

Sys.time();
test_dir <- "D:\\cursuri\\CKME136_CapstoneProject\\enron_dataset\\tmp";
enron <- Corpus(DirSource(test_dir));

Sys.time();
enron <- tm_map(enron, content_transformer(tolower));

Sys.time();
enron <- tm_map(enron, removeNumbers);

Sys.time();
enron <- tm_map(enron, stripWhitespace);

Sys.time();
enron <- tm_map(enron, removeWords, stopwords("english"));

Sys.time();
enron <- tm_map(enron, stemDocument, language = "english");

Sys.time();
exclude_words  <- readLines("D:\\cursuri\\CKME136_CapstoneProject\\final\\emails_topics\\exclude_words_list.txt");
enron    <- tm_map(enron, removeWords, exclude_words);

Sys.time();
dtm <- DocumentTermMatrix(enron);
Sys.time();

dtm_c <- rollup(dtm, 1, FUN = sum);
Sys.time();

m <- as.matrix(dtm_c);
s <- as.simple_triplet_matrix(m);
dtm_colsum <- as.DocumentTermMatrix(s, weighting = weightTf);

Sys.time();
lda8 <- LDA(dtm_colsum, k = 4);

Sys.time();
terms(lda8,10);

Sys.time();




