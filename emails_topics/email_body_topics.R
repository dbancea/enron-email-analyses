
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

# Sys.time function is used to capture the execution time for each part of the code

# create the corpus from the files which have the e-mail content
Sys.time();
test_dir <- "D:\\cursuri\\CKME136_CapstoneProject\\enron_dataset\\tmp";
enron <- Corpus(DirSource(test_dir));

# documents cleanup with tm_map function
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

# exclude some specific words which are in the exclude_words_list.txt from corpus
# the words excluded don't provide too much information related to topics
# the words list was done iterative, LDA was executed couple of times and each time more words were added in the file
Sys.time();
exclude_words  <- readLines("D:\\cursuri\\CKME136_CapstoneProject\\final\\emails_topics\\exclude_words_list.txt");
enron    <- tm_map(enron, removeWords, exclude_words);

# create document term matrix
Sys.time();
dtm <- DocumentTermMatrix(enron);
Sys.time();


# sum all columns since LDA return an error that there are empty rows
dtm_c <- rollup(dtm, 1, FUN = sum);
Sys.time();

# the dtm_c lost the weighthing information and LDA failed
# to added back dtm_c is trasformed to matrix, simple triplet matrix and DocumentTermMatrix
m <- as.matrix(dtm_c);
s <- as.simple_triplet_matrix(m);
dtm_colsum <- as.DocumentTermMatrix(s, weighting = weightTf);

# find the main 4 topics
Sys.time();
lda4 <- LDA(dtm_colsum, k = 4);

# display the first 10 words from the main 4 topics
Sys.time();
terms(lda4,10);

Sys.time();




