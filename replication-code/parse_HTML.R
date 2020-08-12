###########################################################################
# Joshua C. Fjelstul, Ph.D.
# eutris R package
###########################################################################

# this script requires raw data that is not available in the GitHub repo
# this script is for replication purposes only
# do not attempt run this script

# define pipe function
`%>%` <- magrittr::`%>%`

##################################################
# functions to extract data
##################################################

# file <- "data-raw/HTML-pages/notification_2012_617.html"

extract_metadata <- function(file) {
  html <- xml2::read_html(file)
  div <- html %>% rvest::html_nodes("div")
  class <- div %>% rvest::html_attr("class")
  div <- div[!is.na(class)]
  class <- class[!is.na(class)]
  div <- div[class == "row trisDetails"]
  text <- div %>% rvest::html_text()
  text <- stringr::str_squish(text)
  text <- stringr::str_replace(text, "var notifYear.*", "")
  return(text)
}

##################################################
# read in TRIS data
##################################################

# load notification data
load("data/notifications.RData")

# year
notifications$year <- stringr::str_extract(notifications$notification_number, "^[0-9]{4}")

# number
notifications$number <- stringr::str_extract(notifications$notification_number, "/[0-9]+")
notifications$number <- stringr::str_extract(notifications$number, "[0-9]+")

# file
notifications$file <- stringr::str_c("data-raw/HTML-pages/notification_", notifications$year, "_", notifications$number, ".html")

# drop HTML file with an error
notifications <- dplyr::filter(notifications, !stringr::str_detect(file, "notification_2019_133.html"))

# extract metadata
metadata <- plyr::alply(.data = notifications$file, .margin = 1, .fun = extract_metadata, .progress = "text", .inform = TRUE)
notifications$metadata <- as.character(metadata)
notifications$metadata[notifications$metadata == "character(0)"] <- NA

##################################################
# function to clean text
##################################################

# headings
headings <- "(1\\. structured information line|2\\. member state|3\\. department responsible|3\\. originating department|4\\. notification number|5\\. title|6\\. products concerned|7\\. notification under another act|8\\. main content|9\\. brief statement of grounds|10\\. reference documents - basic texts|11\\. invocation of the emergency procedure|12\\. grounds for the emergency|13\\. confidentiality|14\\. fiscal measures|15\\. impact assessment|16\\. tbt and sps aspects)"

extract_heading <- function(x, heading, headings) {
  x <- stringr::str_extract(x, stringr::str_c(heading, ".*?", headings))
  return(x)
}

remove_headings <- function(x, headings) {
  x <- stringr::str_replace_all(x, headings, "")
  return(x)
}

clean_text <- function(x) {
  x <- stringr::str_to_lower(x)
  x <- stringr::str_replace_all(x, "[^[:alpha:]0-9 ]+", " ")
  x <- stringr::str_squish(x)
  x[x == ""] <- NA
  return(x)
}

clean_list <- function(x) {
  x <- stringr::str_split(x, ",")
  x <- unlist(x)
  x <- stringr::str_squish(x)
  x <- x[x != ""]
  x <- x[order(x)]
  x <- unique(x)
  x <- stringr::str_c(x, collapse = ", ")
  return(x)
}

##################################################
# comments
##################################################

# clean text
notifications$comments <- stringr::str_extract(notifications$metadata, "Issue of comments by:.*?:")
notifications$comments <- stringr::str_replace(notifications$comments, "Issue of comments by:", "")
notifications$comments <- stringr::str_replace(notifications$comments, "Issue of detailed opinion by.*", "")
notifications$comments <- stringr::str_replace(notifications$comments, "Draft Text.*", "")
notifications$comments <- stringr::str_replace(notifications$comments, "Final Text.*", "")
notifications$comments <- stringr::str_replace(notifications$comments, "Message Text.*", "")
notifications$comments <- stringr::str_replace(notifications$comments, "Postponement.*", "")
notifications$comments <- stringr::str_replace(notifications$comments, "EFTA Surveillance Authority", "European Free Trade Association (EFTA)")
notifications$comments <- stringr::str_squish(notifications$comments)
notifications$comments <- stringr::str_replace(notifications$comments, "^,+", "")
notifications$comments <- stringr::str_squish(notifications$comments)
notifications$comments[notifications$comments == ""] <- NA
for(i in 1:nrow(notifications)) {
  notifications$comments[i] <- clean_list(notifications$comments[i])
}

# check
x <- stringr::str_split(notifications$comments, ",")
x <- unlist(x)
x <- stringr::str_squish(x)
table(x)

# Commission comments
notifications$commission_comment <- as.numeric(stringr::str_detect(notifications$comments, "Commission"))
notifications$commission_comment[is.na(notifications$commission_comment)] <- 0

##################################################
# detailed opinions
##################################################

# clean text
notifications$opinions <- stringr::str_extract(notifications$metadata, "Issue of detailed opinion by:.*?:")
notifications$opinions <- stringr::str_replace(notifications$opinions, "Issue of detailed opinion by:", "")
notifications$opinions <- stringr::str_replace(notifications$opinions, "Draft Text.*", "")
notifications$opinions <- stringr::str_replace(notifications$opinions, "Final Text.*", "")
notifications$opinions <- stringr::str_replace(notifications$opinions, "Message Text.*", "")
notifications$opinions <- stringr::str_replace(notifications$opinions, "Postponement.*", "")
notifications$opinions <- stringr::str_squish(notifications$opinions)
notifications$opinions <- stringr::str_replace(notifications$opinions, "^,+", "")
notifications$opinions <- stringr::str_squish(notifications$opinions)
notifications$opinions[notifications$opinions == ""] <- NA
for(i in 1:nrow(notifications)) {
  notifications$opinions[i] <- clean_list(notifications$opinions[i])
}

# check
# x <- stringr::str_split(notifications$opinions, ",")
# x <- unlist(x)
# x <- stringr::str_squish(x)
# table(x)

# Commission opinions
notifications$commission_opinion <- as.numeric(stringr::str_detect(notifications$opinions, "Commission"))
notifications$commission_opinion[is.na(notifications$commission_opinion)] <- 0

##################################################
# make other variables
##################################################

# postponement
notifications$postponement <- as.numeric(stringr::str_detect(notifications$metadata, "Postponement"))

# clean metadata
notifications$metadata <- stringr::str_to_lower(notifications$metadata)

# date received
# notifications$date_received <- stringr::str_extract(notifications$metadata, "date received: [0-9]+/[0-9]+/[0-9]+")
# notifications$date_received <- stringr::str_extract(notifications$date_received, "[0-9]+/[0-9]+/[0-9]+")
# notifications$date_received <- lubridate::dmy(notifications$date_received)

# date of end of standstill
# notifications$date_end_standstill <- stringr::str_extract(notifications$metadata, "end of standstill: ([0-9]+/[0-9]+/[0-9]+)")
# notifications$date_end_standstill <- stringr::str_extract(notifications$date_end_standstill, "[0-9]+/[0-9]+/[0-9]+")
# notifications$date_end_standstill <- lubridate::dmy(notifications$date_end_standstill)

# title
notifications$title <- extract_heading(notifications$metadata, "5\\. title", headings)
notifications$title <- remove_headings(notifications$title, headings)
notifications$title <- clean_text(notifications$title)

# products
notifications$products <- extract_heading(notifications$metadata, "6\\. products concerned", headings)
notifications$products <- remove_headings(notifications$products, headings)
notifications$products <- clean_text(notifications$products)

# description
notifications$description <- extract_heading(notifications$metadata, "8\\. main content", headings)
notifications$description <- remove_headings(notifications$description, headings)
notifications$description <- clean_text(notifications$description)

# grounds
notifications$grounds <- extract_heading(notifications$metadata, "9\\. brief statement of grounds", headings)
notifications$grounds <- remove_headings(notifications$grounds, headings)
notifications$grounds <- clean_text(notifications$grounds)

##################################################
# network data: comments
##################################################

# select variables
comments <- dplyr::select(
  notifications,
  member_state, notification_number, start_date, end_date, comments
)

# drop notifications with no comments
comments <- dplyr::filter(comments, !is.na(comments))

# one row per comment
comments <- tidyr::separate_rows(comments, comments, sep = ",")

# rename variable
comments <- dplyr::rename(comments, notification_by = member_state, comment_by = comments)

# clean member state names
comments$comment_by <- stringr::str_squish(comments$comment_by)

# year
comments$start_year <- lubridate::year(comments$start_date)
comments$end_year <- lubridate::year(comments$end_date)

# comment number
comments <- comments %>%
  dplyr::group_by(notification_number) %>%
  dplyr::mutate(comment_number = 1:dplyr::n())

# comment ID
comments$comment_ID <- stringr::str_c(comments$notification_number, comments$comment_number, sep = "-")

# arrange
comments <- dplyr::arrange(comments, start_date, notification_number, comment_by)

# key ID
comments$key_ID <- 1:nrow(comments)

# select variables
comments <- dplyr::select(
  comments,
  key_ID, notification_number, notification_by,
  start_date, start_year, end_date, end_year,
  comment_ID, comment_number, comment_by
)

##################################################
# network data: opinions
##################################################

# select variables
opinions <- dplyr::select(
  notifications,
  member_state, notification_number, start_date, end_date, opinions
)

# drop notifications with no comments
opinions <- dplyr::filter(opinions, !is.na(opinions))

# one row per comment
opinions <- tidyr::separate_rows(opinions, opinions, sep = ",")

# rename variable
opinions <- dplyr::rename(opinions, notification_by = member_state, opinion_by = opinions)

# clean member state names
opinions$opinion_by <- stringr::str_squish(opinions$opinion_by)

# year
opinions$start_year <- lubridate::year(opinions$start_date)
opinions$end_year <- lubridate::year(opinions$end_date)

##################################################
# export
##################################################

# select variables
notifications <- dplyr::select(
  notifications,
  member_state, notification_number, year, number, start_date, end_date, duration, postponement, member_state_comments, commission_comment, member_state_opinions, commission_opinion, member_state_responses, commission_response
)

# arrange
out$number <- as.numeric(out$number)
out <- arrange(out, year, number)

# drop
out$drop <- str_extract(out$notification_number, "^[0-9]{4}")
out <- filter(out, drop >= 1994)
out$drop <- NULL
out <- filter(out, number < 1000)

# set working directory
setwd("~/Dropbox/Professional/Projects/Implementation Paper/Empirics/Data/")

# write data
write.csv(out, "TRIS_data_extended.csv", row.names = FALSE)

###########################################################################
# end R script
###########################################################################
