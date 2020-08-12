###########################################################################
# Joshua C. Fjelstul, Ph.D.
# eutris R package
###########################################################################

# define pipe function
`%>%` <- magrittr::`%>%`

# load data
load("data/notifications.RData")

##################################################
# network data
##################################################

# select variables
comments <- dplyr::select(
  notifications,
  notification_ID, notification_by, start_date, end_date, comments
)

# drop notifications with no comments
comments <- dplyr::filter(comments, !is.na(comments))

# one row per comment
comments <- tidyr::separate_rows(comments, comments, sep = ",")

# rename variable
comments <- dplyr::rename(comments, comment_by = comments)

# clean member state names
comments$comment_by <- stringr::str_squish(comments$comment_by)

# merge in codes
codes <- read.csv("data-raw/entity-codes.csv", stringsAsFactors = FALSE)
comments <- dplyr::left_join(comments, codes, by = c("comment_by" = "entity"))

# year
comments$start_year <- lubridate::year(comments$start_date)
comments$end_year <- lubridate::year(comments$end_date)

# comment ID
comments$comment_ID <- stringr::str_c(comments$notification_ID, comments$entity_code, sep = ":")
comments$comment_ID <- stringr::str_replace(comments$comment_ID, ":N:", ":C:")

# arrange
comments <- dplyr::arrange(comments, start_date, notification_ID, comment_ID)

# key ID
comments$key_ID <- 1:nrow(comments)

# select variables
comments <- dplyr::select(
  comments,
  key_ID, notification_ID, notification_by,
  start_date, start_year, end_date, end_year,
  comment_ID, comment_by
)

# save
save(comments, file = "data/comments.RData")

##################################################
# entity-year data
##################################################

# template
template <- expand.grid(codes$entity, 1988:2020, stringsAsFactors = FALSE)
names(template) <- c("comment_by", "year")

# collapse by member state and by year
comments_EY <- comments %>%
  dplyr::group_by(comment_by, start_year) %>%
  dplyr::summarize(
    count_comments = dplyr::n()
  ) %>% dplyr::ungroup()

# rename variable
comments_EY <- dplyr::rename(comments_EY, year = start_year)

# merge
comments_EY <- dplyr::left_join(template, comments_EY, by = c("comment_by", "year"))

# convert to a tibble
comments_EY <- dplyr::as_tibble(comments_EY)

# code zeros
comments_EY$count_comments[is.na(comments_EY$count_comments)] <- 0

# drop invalid entity-years
comments_EY$drop <- FALSE
comments_EY$drop[comments_EY$comment_by == "Turkey" & comments_EY$year < 1995] <- TRUE
comments_EY$drop[comments_EY$comment_by == "Liechtenstein" & comments_EY$year < 1991] <- TRUE
comments_EY$drop[comments_EY$comment_by %in% c("Cyprus", "Czech Republic", "Estonia", "Hungary", "Latvia", "Lithuania", "Malta", "Poland", "Slovakia", "Slovenia") & comments_EY$year < 2004] <- TRUE
comments_EY$drop[comments_EY$comment_by %in% c("Bulgaria", "Romania") & comments_EY$year < 2007] <- TRUE
comments_EY$drop[comments_EY$comment_by == "Croatia" & comments_EY$year < 2013] <- TRUE
comments_EY <- dplyr::filter(comments_EY, !drop)

# arrange
comments_EY <- dplyr::arrange(comments_EY, year, comment_by)

# key ID
comments_EY$key_ID <- 1:nrow(comments_EY)

# select variables
comments_EY <- dplyr::select(
  comments_EY,
  key_ID, year, comment_by, count_comments
)

# save
save(comments_EY, file = "data/comments_EY.RData")

##################################################
# directed dyad-year data
##################################################

# template
template <- expand.grid(codes$entity[1:33], codes$entity, 1988:2020, stringsAsFactors = FALSE)
names(template) <- c("notification_by", "comment_by", "year")

# collapse by member state and by year
comments_DDY <- comments %>%
  dplyr::group_by(notification_by, comment_by, start_year) %>%
  dplyr::summarize(
    count_comments = dplyr::n()
  ) %>% dplyr::ungroup()

# rename variable
comments_DDY <- dplyr::rename(comments_DDY, year = start_year)

# merge
comments_DDY <- dplyr::left_join(template, comments_DDY, by = c("notification_by", "comment_by", "year"))

# convert to a tibble
comments_DDY <- dplyr::as_tibble(comments_DDY)

# code zeros
comments_DDY$count_comments[is.na(comments_DDY$count_comments)] <- 0

# drop invalid entity-years
comments_DDY$drop <- FALSE
comments_DDY$drop[comments_DDY$comment_by == "Turkey" & comments_DDY$year < 1995] <- TRUE
comments_DDY$drop[comments_DDY$comment_by == "Liechtenstein" & comments_DDY$year < 1991] <- TRUE
comments_DDY$drop[comments_DDY$comment_by %in% c("Cyprus", "Czech Republic", "Estonia", "Hungary", "Latvia", "Lithuania", "Malta", "Poland", "Slovakia", "Slovenia") & comments_DDY$year < 2004] <- TRUE
comments_DDY$drop[comments_DDY$comment_by %in% c("Bulgaria", "Romania") & comments_DDY$year < 2007] <- TRUE
comments_DDY$drop[comments_DDY$comment_by == "Croatia" & comments_DDY$year < 2013] <- TRUE
comments_DDY <- dplyr::filter(comments_DDY, !drop)
comments_DDY$drop <- FALSE
comments_DDY$drop[comments_DDY$notification_by == "Turkey" & comments_DDY$year < 1995] <- TRUE
comments_DDY$drop[comments_DDY$notification_by == "Liechtenstein" & comments_DDY$year < 1991] <- TRUE
comments_DDY$drop[comments_DDY$notification_by %in% c("Cyprus", "Czech Republic", "Estonia", "Hungary", "Latvia", "Lithuania", "Malta", "Poland", "Slovakia", "Slovenia") & comments_DDY$year < 2004] <- TRUE
comments_DDY$drop[comments_DDY$notification_by %in% c("Bulgaria", "Romania") & comments_DDY$year < 2007] <- TRUE
comments_DDY$drop[comments_DDY$notification_by == "Croatia" & comments_DDY$year < 2013] <- TRUE
comments_DDY <- dplyr::filter(comments_DDY, !drop)

# arrange
comments_DDY <- dplyr::arrange(comments_DDY, year, comment_by, notification_by)

# key ID
comments_DDY$key_ID <- 1:nrow(comments_DDY)

# select variables
comments_DDY <- dplyr::select(
  comments_DDY,
  key_ID, year, comment_by, notification_by, count_comments
)

# save
save(comments_DDY, file = "data/comments_DDY.RData")

##################################################
# network data
##################################################

# create a new tibble
comments_network <- comments_DDY

# rename variables
names(comments_network) <- c("key_ID", "year", "from_node", "to_node", "edge_weight")

# drop dyads without an edge
comments_network <- dplyr::filter(comments_network, edge_weight != 0)

# arrange
comments_network <- dplyr::arrange(comments_network, year, from_node, to_node)

# key ID
comments_network$key_ID <- 1:nrow(comments_network)

# select variables
comments_network <- dplyr::select(
  comments_network,
  key_ID, year, from_node, to_node, edge_weight
)

# save
save(comments_network, file = "data/comments_network.RData")

###########################################################################
# end R script
###########################################################################
