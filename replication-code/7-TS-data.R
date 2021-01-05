###########################################################################
# Joshua C. Fjelstul, Ph.D.
# eutris R package
###########################################################################

# define pipe function
`%>%` <- magrittr::`%>%`

# load data
load("data/notifications.RData")
load("data/comments.RData")
load("data/opinions.Rdata")

##################################################
# template
##################################################

# template
template_TS <- expand.grid(1988:2020, stringsAsFactors = FALSE)
names(template_TS) <- c("year")

##################################################
# notifications
##################################################

# collapse by member state and by year
notifications_TS <- notifications %>%
  dplyr::group_by(start_year) %>%
  dplyr::summarize(
    count_notifications = dplyr::n()
  ) %>% dplyr::ungroup()

# rename variable
notifications_TS <- dplyr::rename(notifications_TS, year = start_year)

# merge
notifications_TS <- dplyr::left_join(template_TS, notifications_TS, by = "year")

# convert to a tibble
notifications_TS <- dplyr::as_tibble(notifications_TS)

# code zeros
notifications_TS$count_notifications[is.na(notifications_TS$count_notifications)] <- 0

# key ID
notifications_TS$key_ID <- 1:nrow(notifications_TS)

# select variables
notifications_TS <- dplyr::select(
  notifications_TS,
  key_ID, year, count_notifications
)

# save
save(notifications_TS, file = "data/notifications_TS.RData")

##################################################
# comments
##################################################

# collapse by member state and by year
comments_TS <- comments %>%
  dplyr::group_by(start_year) %>%
  dplyr::summarize(
    count_comments = dplyr::n()
  ) %>% dplyr::ungroup()

# rename variable
comments_TS <- dplyr::rename(comments_TS, year = start_year)

# merge
comments_TS <- dplyr::left_join(template_TS, comments_TS, by = "year")

# convert to a tibble
comments_TS <- dplyr::as_tibble(comments_TS)

# code zeros
comments_TS$count_comments[is.na(comments_TS$count_comments)] <- 0

# key ID
comments_TS$key_ID <- 1:nrow(comments_TS)

# select variables
comments_TS <- dplyr::select(
  comments_TS,
  key_ID, year, count_comments
)

# save
save(comments_TS, file = "data/comments_TS.RData")

##################################################
# opinions
##################################################

# collapse by member state and by year
opinions_TS <- opinions %>%
  dplyr::group_by(start_year) %>%
  dplyr::summarize(
    count_opinions = dplyr::n()
  ) %>% dplyr::ungroup()

# rename variable
opinions_TS <- dplyr::rename(opinions_TS, year = start_year)

# merge
opinions_TS <- dplyr::left_join(template_TS, opinions_TS, by = "year")

# convert to a tibble
opinions_TS <- dplyr::as_tibble(opinions_TS)

# code zeros
opinions_TS$count_opinions[is.na(opinions_TS$count_opinions)] <- 0

# key ID
opinions_TS$key_ID <- 1:nrow(opinions_TS)

# select variables
opinions_TS <- dplyr::select(
  opinions_TS,
  key_ID, year, count_opinions
)

# save
save(opinions_TS, file = "data/opinions_TS.RData")

###########################################################################
# end R script
###########################################################################
