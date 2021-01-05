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

# read in codes
codes <- read.csv("data-raw/entity-codes.csv")

##################################################
# template
##################################################

# template
template_CSTS <- expand.grid(codes$entity, 1988:2020, stringsAsFactors = FALSE)
names(template_CSTS) <- c("entity", "year")

# drop invalid entity-years
template_CSTS$drop <- FALSE
template_CSTS$drop[template_CSTS$entity == "Turkey" & template_CSTS$year < 1995] <- TRUE
template_CSTS$drop[template_CSTS$entity == "Liechtenstein" & template_CSTS$year < 1991] <- TRUE
template_CSTS$drop[template_CSTS$entity %in% c("Cyprus", "Czech Republic", "Estonia", "Hungary", "Latvia", "Lithuania", "Malta", "Poland", "Slovakia", "Slovenia") & template_CSTS$year < 2004] <- TRUE
template_CSTS$drop[template_CSTS$entity %in% c("Bulgaria", "Romania") & template_CSTS$year < 2007] <- TRUE
template_CSTS$drop[template_CSTS$entity == "Croatia" & template_CSTS$year < 2013] <- TRUE
template_CSTS$drop[template_CSTS$entity %in% c("Commission", "European Free Trade Association")] <- TRUE
template_CSTS <- dplyr::filter(template_CSTS, !drop)
template_CSTS <- dplyr::select(template_CSTS, -drop)

##################################################
# notifications
##################################################

# collapse by member state and by year
notifications_CSTS <- notifications %>%
  dplyr::group_by(notification_by, start_year) %>%
  dplyr::summarize(
    count_notifications = dplyr::n()
  ) %>% dplyr::ungroup()

# rename variable
notifications_CSTS <- dplyr::rename(notifications_CSTS, year = start_year)

# merge
notifications_CSTS <- dplyr::left_join(template_CSTS, notifications_CSTS, by = c("entity" = "notification_by", "year"))

# convert to a tibble
notifications_CSTS <- dplyr::as_tibble(notifications_CSTS)

# code zeros
notifications_CSTS$count_notifications[is.na(notifications_CSTS$count_notifications)] <- 0

# merge in entity data
notifications_CSTS <- dplyr::left_join(notifications_CSTS, codes, by = c("entity"))

# rename variables
notifications_CSTS <- dplyr::rename(
  notifications_CSTS,
  notification_by = entity,
  notification_by_ID = entity_ID,
  notification_by_code = entity_code
)

# arrange
notifications_CSTS <- dplyr::arrange(notifications_CSTS, year, notification_by_ID)

# key ID
notifications_CSTS$key_ID <- 1:nrow(notifications_CSTS)

# select variables
notifications_CSTS <- dplyr::select(
  notifications_CSTS,
  key_ID, year, 
  notification_by_ID, notification_by, notification_by_code,
  count_notifications
)

# save
save(notifications_CSTS, file = "data/notifications_CSTS.RData")

##################################################
# template
##################################################

# template
template_CSTS <- expand.grid(codes$entity, 1988:2020, stringsAsFactors = FALSE)
names(template_CSTS) <- c("entity", "year")

# drop invalid entity-years
template_CSTS$drop <- FALSE
template_CSTS$drop[template_CSTS$entity == "Turkey" & template_CSTS$year < 1995] <- TRUE
template_CSTS$drop[template_CSTS$entity == "Liechtenstein" & template_CSTS$year < 1991] <- TRUE
template_CSTS$drop[template_CSTS$entity %in% c("Cyprus", "Czech Republic", "Estonia", "Hungary", "Latvia", "Lithuania", "Malta", "Poland", "Slovakia", "Slovenia") & template_CSTS$year < 2004] <- TRUE
template_CSTS$drop[template_CSTS$entity %in% c("Bulgaria", "Romania") & template_CSTS$year < 2007] <- TRUE
template_CSTS$drop[template_CSTS$entity == "Croatia" & template_CSTS$year < 2013] <- TRUE
template_CSTS <- dplyr::filter(template_CSTS, !drop)
template_CSTS <- dplyr::select(template_CSTS, -drop)

##################################################
# comments
##################################################

# collapse by member state and by year
comments_CSTS <- comments %>%
  dplyr::group_by(comment_by, start_year) %>%
  dplyr::summarize(
    count_comments = dplyr::n()
  ) %>% dplyr::ungroup()

# rename variable
comments_CSTS <- dplyr::rename(comments_CSTS, year = start_year)

# merge
comments_CSTS <- dplyr::left_join(template_CSTS, comments_CSTS, by = c("entity" = "comment_by", "year"))

# convert to a tibble
comments_CSTS <- dplyr::as_tibble(comments_CSTS)

# code zeros
comments_CSTS$count_comments[is.na(comments_CSTS$count_comments)] <- 0

# merge in entity data
comments_CSTS <- dplyr::left_join(comments_CSTS, codes, by = c("entity"))

# rename variables
comments_CSTS <- dplyr::rename(
  comments_CSTS,
  comment_by = entity,
  comment_by_ID = entity_ID,
  comment_by_code = entity_code
)

# arrange
comments_CSTS <- dplyr::arrange(comments_CSTS, year, comment_by_ID)

# key ID
comments_CSTS$key_ID <- 1:nrow(comments_CSTS)

# select variables
comments_CSTS <- dplyr::select(
  comments_CSTS,
  key_ID, year, 
  comment_by_ID, comment_by, comment_by_code, 
  count_comments
)

# save
save(comments_CSTS, file = "data/comments_CSTS.RData")

##################################################
# opinions
##################################################

# collapse by member state and by year
opinions_CSTS <- opinions %>%
  dplyr::group_by(opinion_by, start_year) %>%
  dplyr::summarize(
    count_opinions = dplyr::n()
  ) %>% dplyr::ungroup()

# rename variable
opinions_CSTS <- dplyr::rename(opinions_CSTS, year = start_year)

# merge
opinions_CSTS <- dplyr::left_join(template_CSTS, opinions_CSTS, by = c("entity" = "opinion_by", "year"))

# convert to a tibble
opinions_CSTS <- dplyr::as_tibble(opinions_CSTS)

# code zeros
opinions_CSTS$count_opinions[is.na(opinions_CSTS$count_opinions)] <- 0

# merge in entity data
opinions_CSTS <- dplyr::left_join(opinions_CSTS, codes, by = c("entity"))

# rename variables
opinions_CSTS <- dplyr::rename(
  opinions_CSTS,
  opinion_by = entity,
  opinion_by_ID = entity_ID,
  opinion_by_code = entity_code
)

# arrange
opinions_CSTS <- dplyr::arrange(opinions_CSTS, year, opinion_by_ID)

# key ID
opinions_CSTS$key_ID <- 1:nrow(opinions_CSTS)

# select variables
opinions_CSTS <- dplyr::select(
  opinions_CSTS,
  key_ID, year, 
  opinion_by_ID, opinion_by, opinion_by_code, 
  count_opinions
)

# save
save(opinions_CSTS, file = "data/opinions_CSTS.RData")

###########################################################################
# end R script
###########################################################################
