###########################################################################
# Joshua C. Fjelstul, Ph.D.
# eutris R package
###########################################################################

# define pipe function
`%>%` <- magrittr::`%>%`

##################################################
# functions
##################################################

# headings
headings <- "(1\\. structured information line|2\\. member state|3\\. department responsible|3\\. originating department|4\\. notification number|5\\. title|6\\. products concerned|7\\. notification under another act|8\\. main content|9\\. brief statement of grounds|10\\. reference documents - basic texts|11\\. invocation of the emergency procedure|12\\. grounds for the emergency|13\\. confidentiality|14\\. fiscal measures|15\\. impact assessment|16\\. tbt and sps aspects)"

# function to extract headings from the metadata
extract_heading <- function(x, heading, headings) {
  x <- stringr::str_extract(x, stringr::str_c(heading, ".*?", headings))
  return(x)
}

# function to remove headings from extracted text
remove_headings <- function(x, headings) {
  x <- stringr::str_replace_all(x, headings, "")
  return(x)
}

# function to clean text
clean_text <- function(x) {
  x <- stringr::str_to_lower(x)
  x <- stringr::str_replace_all(x, "[^[:alpha:]0-9 ]+", " ")
  x <- stringr::str_squish(x)
  x[x == ""] <- NA
  return(x)
}

# function to clean a comma-separated list
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
# load data
##################################################

# load
load("data-raw/notifications_raw_metadata.Rdata")

# rename
notifications <- notifications_raw_metadata
rm(notifications_raw_metadata)

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
notifications$comments <- stringr::str_replace_all(notifications$comments, "EFTA Surveillance Authority", "European Free Trade Association")
notifications$comments <- stringr::str_replace_all(notifications$comments, "European Free Trade Association .EFTA.", "European Free Trade Association")
notifications$comments <- stringr::str_squish(notifications$comments)
notifications$comments <- stringr::str_replace(notifications$comments, "^,+", "")
notifications$comments <- stringr::str_squish(notifications$comments)
notifications$comments[notifications$comments == ""] <- NA
for(i in 1:nrow(notifications)) {
  notifications$comments[i] <- clean_list(notifications$comments[i])
}

# check
# x <- stringr::str_split(notifications$comments, ",")
# x <- unlist(x)
# x <- stringr::str_squish(x)
# table(x)

# Commission comments
notifications$commission_comment <- as.numeric(stringr::str_detect(notifications$comments, "Commission"))
notifications$commission_comment[is.na(notifications$commission_comment)] <- 0

# count comments
notifications$count_comments <- stringr::str_count(notifications$comments, "[A-Za-z ]+")
notifications$count_comments[is.na(notifications$count_comments)] <- 0

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

# count comments
notifications$count_opinions <- stringr::str_count(notifications$opinions, "[A-Za-z ]+")
notifications$count_opinions[is.na(notifications$count_opinions)] <- 0

##################################################
# make other variables
##################################################

# postponement
notifications$postponement <- as.numeric(stringr::str_detect(notifications$metadata, "Postponement"))

# clean metadata
notifications$metadata <- stringr::str_to_lower(notifications$metadata)

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
# years
##################################################

# start year
notifications$start_year <- lubridate::year(notifications$start_date)

# end year
notifications$end_year <- lubridate::year(notifications$end_date)

##################################################
# notification ID
##################################################

# member state code
codes <- read.csv("data-raw/entity-codes.csv", stringsAsFactors = FALSE)
notifications <- dplyr::left_join(notifications, codes, by = c("member_state" = "entity"))
# table(notifications$entity_code, useNA = "always")

# pad number
notifications$number <- stringr::str_pad(notifications$number, width = 4, side = "left", pad = "0")

# notification ID
notifications$notification_ID <- stringr::str_c("TRIS", notifications$year, notifications$number, notifications$entity_code, "N", sep = ":")

##################################################
# organize data
##################################################

# rename variable
notifications <- dplyr::rename(notifications, notification_by = member_state)

# arrange
notifications <- dplyr::arrange(notifications, start_date, notification_ID)

# key ID
notifications$key_ID <- 1:nrow(notifications)

# select variables
notifications_extended <- dplyr::select(
  notifications,
  key_ID, notification_ID, notification_by,
  start_date, start_year, end_date, end_year, postponement,
  comments, count_comments, commission_comment, opinions, count_opinions, commission_opinion,
  title, description, grounds, products
)

# select variables
notifications <- dplyr::select(
  notifications,
  key_ID, notification_ID, notification_by,
  start_date, start_year, end_date, end_year, postponement,
  comments, count_comments, commission_comment, opinions, count_opinions, commission_opinion,
)

# save
save(notifications, file = "data/notifications.RData")
save(notifications_extended, file = "data/notifications_extended.RData")

##################################################
# entity-year data
##################################################

# template
template <- expand.grid(codes$entity, 1988:2020, stringsAsFactors = FALSE)
names(template) <- c("notification_by", "year")

# collapse by member state and by year
notifications_EY <- notifications %>%
  dplyr::group_by(notification_by, start_year) %>%
  dplyr::summarize(
    count_notifications = dplyr::n()
  ) %>% dplyr::ungroup()

# rename variable
notifications_EY <- dplyr::rename(notifications_EY, year = start_year)

# merge
notifications_EY <- dplyr::left_join(template, notifications_EY, by = c("notification_by", "year"))

# convert to a tibble
notifications_EY <- dplyr::as_tibble(notifications_EY)

# code zeros
notifications_EY$count_notifications[is.na(notifications_EY$count_notifications)] <- 0

# drop invalid entity-years
notifications_EY$drop <- FALSE
notifications_EY$drop[notifications_EY$notification_by == "Turkey" & notifications_EY$year < 1995] <- TRUE
notifications_EY$drop[notifications_EY$notification_by == "Liechtenstein" & notifications_EY$year < 1991] <- TRUE
notifications_EY$drop[notifications_EY$notification_by %in% c("Cyprus", "Czech Republic", "Estonia", "Hungary", "Latvia", "Lithuania", "Malta", "Poland", "Slovakia", "Slovenia") & notifications_EY$year < 2004] <- TRUE
notifications_EY$drop[notifications_EY$notification_by %in% c("Bulgaria", "Romania") & notifications_EY$year < 2007] <- TRUE
notifications_EY$drop[notifications_EY$notification_by == "Croatia" & notifications_EY$year < 2013] <- TRUE
notifications_EY <- dplyr::filter(notifications_EY, !drop)

# arrange
notifications_EY <- dplyr::arrange(notifications_EY, year, notification_by)

# key ID
notifications_EY$key_ID <- 1:nrow(notifications_EY)

# select variables
notifications_EY <- dplyr::select(
  notifications_EY,
  key_ID, year, notification_by, count_notifications
)

# save
save(notifications_EY, file = "data/notifications_EY.RData")

###########################################################################
# end R script
###########################################################################
