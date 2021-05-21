################################################################################
# Joshua C. Fjelstul, Ph.D.
# eutr R package
################################################################################

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
template_ts <- expand.grid(1988:2020, stringsAsFactors = FALSE)
names(template_ts) <- c("year")

##################################################
# notifications
##################################################

# collapse by member state and by year
notifications_ts <- notifications %>%
  dplyr::group_by(start_year) %>%
  dplyr::summarize(
    count_notifications = dplyr::n()
  ) %>% dplyr::ungroup()

# rename variable
notifications_ts <- dplyr::rename(notifications_ts, year = start_year)

# merge
notifications_ts <- dplyr::left_join(template_ts, notifications_ts, by = "year")

# convert to a tibble
notifications_ts <- dplyr::as_tibble(notifications_ts)

# code zeros
notifications_ts$count_notifications[is.na(notifications_ts$count_notifications)] <- 0

# key ID
notifications_ts$key_id <- 1:nrow(notifications_ts)

# select variables
notifications_ts <- dplyr::select(
  notifications_ts,
  key_id, year, count_notifications
)

# save
save(notifications_ts, file = "data/notifications_ts.RData")

##################################################
# comments
##################################################

# collapse by member state and by year
comments_ts <- comments %>%
  dplyr::group_by(start_year) %>%
  dplyr::summarize(
    count_comments = dplyr::n()
  ) %>% dplyr::ungroup()

# rename variable
comments_ts <- dplyr::rename(comments_ts, year = start_year)

# merge
comments_ts <- dplyr::left_join(template_ts, comments_ts, by = "year")

# convert to a tibble
comments_ts <- dplyr::as_tibble(comments_ts)

# code zeros
comments_ts$count_comments[is.na(comments_ts$count_comments)] <- 0

# key ID
comments_ts$key_id <- 1:nrow(comments_ts)

# select variables
comments_ts <- dplyr::select(
  comments_ts,
  key_id, year, count_comments
)

# save
save(comments_ts, file = "data/comments_ts.RData")

##################################################
# opinions
##################################################

# collapse by member state and by year
opinions_ts <- opinions %>%
  dplyr::group_by(start_year) %>%
  dplyr::summarize(
    count_opinions = dplyr::n()
  ) %>% dplyr::ungroup()

# rename variable
opinions_ts <- dplyr::rename(opinions_ts, year = start_year)

# merge
opinions_ts <- dplyr::left_join(template_ts, opinions_ts, by = "year")

# convert to a tibble
opinions_ts <- dplyr::as_tibble(opinions_ts)

# code zeros
opinions_ts$count_opinions[is.na(opinions_ts$count_opinions)] <- 0

# key ID
opinions_ts$key_id <- 1:nrow(opinions_ts)

# select variables
opinions_ts <- dplyr::select(
  opinions_ts,
  key_id, year, count_opinions
)

# save
save(opinions_ts, file = "data/opinions_ts.RData")

################################################################################
# end R script
################################################################################
