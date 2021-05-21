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

# read in codes
codes <- read.csv("data-raw/entity-codes.csv")

##################################################
# template
##################################################

# template
template_csts <- expand.grid(codes$entity, 1988:2020, stringsAsFactors = FALSE)
names(template_csts) <- c("entity", "year")

# drop invalid entity-years
template_csts$drop <- FALSE
template_csts$drop[template_csts$entity == "Turkey" & template_csts$year < 1995] <- TRUE
template_csts$drop[template_csts$entity == "Liechtenstein" & template_csts$year < 1991] <- TRUE
template_csts$drop[template_csts$entity %in% c("Cyprus", "Czech Republic", "Estonia", "Hungary", "Latvia", "Lithuania", "Malta", "Poland", "Slovakia", "Slovenia") & template_csts$year < 2004] <- TRUE
template_csts$drop[template_csts$entity %in% c("Bulgaria", "Romania") & template_csts$year < 2007] <- TRUE
template_csts$drop[template_csts$entity == "Croatia" & template_csts$year < 2013] <- TRUE
template_csts$drop[template_csts$entity %in% c("Commission", "European Free Trade Association")] <- TRUE
template_csts <- dplyr::filter(template_csts, !drop)
template_csts <- dplyr::select(template_csts, -drop)

##################################################
# notifications_csts
##################################################

# collapse by member state and by year
notifications_csts <- notifications %>%
  dplyr::group_by(notification_by, start_year) %>%
  dplyr::summarize(
    count_notifications = dplyr::n()
  ) %>% dplyr::ungroup()

# rename variable
notifications_csts <- dplyr::rename(notifications_csts, year = start_year)

# merge
notifications_csts <- dplyr::left_join(template_csts, notifications_csts, by = c("entity" = "notification_by", "year"))

# convert to a tibble
notifications_csts <- dplyr::as_tibble(notifications_csts)

# code zeros
notifications_csts$count_notifications[is.na(notifications_csts$count_notifications)] <- 0

# merge in entity data
notifications_csts <- dplyr::left_join(notifications_csts, codes, by = c("entity"))

# rename variables
notifications_csts <- dplyr::rename(
  notifications_csts,
  notification_by = entity,
  notification_by_id = entity_id,
  notification_by_code = entity_code
)

# arrange
notifications_csts <- dplyr::arrange(notifications_csts, year, notification_by_id)

# key ID
notifications_csts$key_id <- 1:nrow(notifications_csts)

# select variables
notifications_csts <- dplyr::select(
  notifications_csts,
  key_id, year, 
  notification_by_id, notification_by, notification_by_code,
  count_notifications
)

# save
save(notifications_csts, file = "data/notifications_csts.RData")

##################################################
# comments_csts_n
##################################################

# collapse by member state and by year
comments_csts_n <- comments %>%
  dplyr::group_by(notification_by, start_year) %>%
  dplyr::summarize(
    count_comments = dplyr::n()
  ) %>% dplyr::ungroup()

# rename variable
comments_csts_n <- dplyr::rename(comments_csts_n, year = start_year)

# merge
comments_csts_n <- dplyr::left_join(template_csts, comments_csts_n, by = c("entity" = "notification_by", "year"))

# convert to a tibble
comments_csts_n <- dplyr::as_tibble(comments_csts_n)

# code zeros
comments_csts_n$count_comments[is.na(comments_csts_n$count_comments)] <- 0

# merge in entity data
comments_csts_n <- dplyr::left_join(comments_csts_n, codes, by = c("entity"))

# rename variables
comments_csts_n <- dplyr::rename(
  comments_csts_n,
  notification_by = entity,
  notification_by_id = entity_id,
  notification_by_code = entity_code
)

# arrange
comments_csts_n <- dplyr::arrange(comments_csts_n, year, notification_by_id)

# key ID
comments_csts_n$key_id <- 1:nrow(comments_csts_n)

# select variables
comments_csts_n <- dplyr::select(
  comments_csts_n,
  key_id, year, 
  notification_by_id, notification_by, notification_by_code,
  count_comments
)

# save
save(comments_csts_n, file = "data/comments_csts_n.RData")

##################################################
# opinions_csts_n
##################################################

# collapse by member state and by year
opinions_csts_n <- opinions %>%
  dplyr::group_by(notification_by, start_year) %>%
  dplyr::summarize(
    count_opinions = dplyr::n()
  ) %>% dplyr::ungroup()

# rename variable
opinions_csts_n <- dplyr::rename(opinions_csts_n, year = start_year)

# merge
opinions_csts_n <- dplyr::left_join(template_csts, opinions_csts_n, by = c("entity" = "notification_by", "year"))

# convert to a tibble
opinions_csts_n <- dplyr::as_tibble(opinions_csts_n)

# code zeros
opinions_csts_n$count_opinions[is.na(opinions_csts_n$count_opinions)] <- 0

# merge in entity data
opinions_csts_n <- dplyr::left_join(opinions_csts_n, codes, by = c("entity"))

# rename variables
opinions_csts_n <- dplyr::rename(
  opinions_csts_n,
  notification_by = entity,
  notification_by_id = entity_id,
  notification_by_code = entity_code
)

# arrange
opinions_csts_n <- dplyr::arrange(opinions_csts_n, year, notification_by_id)

# key ID
opinions_csts_n$key_id <- 1:nrow(opinions_csts_n)

# select variables
opinions_csts_n <- dplyr::select(
  opinions_csts_n,
  key_id, year, 
  notification_by_id, notification_by, notification_by_code,
  count_opinions
)

# save
save(opinions_csts_n, file = "data/opinions_csts_n.RData")

##################################################
# template
##################################################

# template
template_csts <- expand.grid(codes$entity, 1988:2020, stringsAsFactors = FALSE)
names(template_csts) <- c("entity", "year")

# drop invalid entity-years
template_csts$drop <- FALSE
template_csts$drop[template_csts$entity == "Turkey" & template_csts$year < 1995] <- TRUE
template_csts$drop[template_csts$entity == "Liechtenstein" & template_csts$year < 1991] <- TRUE
template_csts$drop[template_csts$entity %in% c("Cyprus", "Czech Republic", "Estonia", "Hungary", "Latvia", "Lithuania", "Malta", "Poland", "Slovakia", "Slovenia") & template_csts$year < 2004] <- TRUE
template_csts$drop[template_csts$entity %in% c("Bulgaria", "Romania") & template_csts$year < 2007] <- TRUE
template_csts$drop[template_csts$entity == "Croatia" & template_csts$year < 2013] <- TRUE
template_csts <- dplyr::filter(template_csts, !drop)
template_csts <- dplyr::select(template_csts, -drop)

##################################################
# comments_csts_s
##################################################

# collapse by member state and by year
comments_csts_s <- comments %>%
  dplyr::group_by(comment_by, start_year) %>%
  dplyr::summarize(
    count_comments = dplyr::n()
  ) %>% dplyr::ungroup()

# rename variable
comments_csts_s <- dplyr::rename(comments_csts_s, year = start_year)

# merge
comments_csts_s <- dplyr::left_join(template_csts, comments_csts_s, by = c("entity" = "comment_by", "year"))

# convert to a tibble
comments_csts_s <- dplyr::as_tibble(comments_csts_s)

# code zeros
comments_csts_s$count_comments[is.na(comments_csts_s$count_comments)] <- 0

# merge in entity data
comments_csts_s <- dplyr::left_join(comments_csts_s, codes, by = c("entity"))

# rename variables
comments_csts_s <- dplyr::rename(
  comments_csts_s,
  comment_by = entity,
  comment_by_id = entity_id,
  comment_by_code = entity_code
)

# arrange
comments_csts_s <- dplyr::arrange(comments_csts_s, year, comment_by_id)

# key ID
comments_csts_s$key_id <- 1:nrow(comments_csts_s)

# select variables
comments_csts_s <- dplyr::select(
  comments_csts_s,
  key_id, year, 
  comment_by_id, comment_by, comment_by_code, 
  count_comments
)

# save
save(comments_csts_s, file = "data/comments_csts_s.RData")

##################################################
# opinions_csts_s
##################################################

# collapse by member state and by year
opinions_csts_s <- opinions %>%
  dplyr::group_by(opinion_by, start_year) %>%
  dplyr::summarize(
    count_opinions = dplyr::n()
  ) %>% dplyr::ungroup()

# rename variable
opinions_csts_s <- dplyr::rename(opinions_csts_s, year = start_year)

# merge
opinions_csts_s <- dplyr::left_join(template_csts, opinions_csts_s, by = c("entity" = "opinion_by", "year"))

# convert to a tibble
opinions_csts_s <- dplyr::as_tibble(opinions_csts_s)

# code zeros
opinions_csts_s$count_opinions[is.na(opinions_csts_s$count_opinions)] <- 0

# merge in entity data
opinions_csts_s <- dplyr::left_join(opinions_csts_s, codes, by = c("entity"))

# rename variables
opinions_csts_s <- dplyr::rename(
  opinions_csts_s,
  opinion_by = entity,
  opinion_by_id = entity_id,
  opinion_by_code = entity_code
)

# arrange
opinions_csts_s <- dplyr::arrange(opinions_csts_s, year, opinion_by_id)

# key ID
opinions_csts_s$key_id <- 1:nrow(opinions_csts_s)

# select variables
opinions_csts_s <- dplyr::select(
  opinions_csts_s,
  key_id, year, 
  opinion_by_id, opinion_by, opinion_by_code, 
  count_opinions
)

# save
save(opinions_csts_s, file = "data/opinions_csts_s.RData")

################################################################################
# end R script
################################################################################
