# Enron-email-analyses


1. Analyze the e-mail networks using igraph between the 150 employees of former Enron and find working groups/communities based on the e-mails frequencies for senders and receivers.
  
     + The source code and the plot files are in email_networkanalysis subdirectory.
     + email_network_analysis.R - R code for network e-mails analyses.
     

2. Find the main topics for the e-mails using LDA from topicsmodels package.
  
     + The source code, word exclude list and output files are in emails_topics subdirectory. 
     + merge_emails_body.R  - extract e-mails' content, merge the conten t and save in a file for each employee.
     + email_body_topics.R  - use tm package for text mining, data cleaning and find text topics with LDA from topicsmodels package.
     + exclude_words_list.txt - file with a list of words which are deleted from docs corpus using tm_map.
     + emails_topics_output_20151123.txt - output file from the execution of email_body_topics.R.
     