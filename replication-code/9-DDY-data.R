###########################################################################
# Joshua C. Fjelstul, Ph.D.
# eutris R package
###########################################################################

# define pipe function
`%>%` <- magrittr::`%>%`

# load data
load("data/comments.RData")
load("data/opinions.Rdata")

# read in codes
codes <- read.csv("data-raw/entity-codes.csv")

##################################################
# template
##################################################

# template
template_DDY <- expand.grid(codes$entity[1:33], codes$entity, 1988:2020, stringsAsFactors = FALSE)
names(template_DDY) <- c("notifier", "responder", "year")

# drop invalid entity-years
template_DDY$drop <- FALSE
template_DDY$drop[template_DDY$notifier == "Turkey" & template_DDY$year < 1995] <- TRUE
template_DDY$drop[template_DDY$notifier == "Liechtenstein" & template_DDY$year < 1991] <- TRUE
template_DDY$drop[template_DDY$notifier %in% c("Cyprus", "Czech Republic", "Estonia", "Hungary", "Latvia", "Lithuania", "Malta", "Poland", "Slovakia", "Slovenia") & template_DDY$year < 2004] <- TRUE
template_DDY$drop[template_DDY$notifier %in% c("Bulgaria", "Romania") & template_DDY$year < 2007] <- TRUE
template_DDY$drop[template_DDY$notifier == "Croatia" & template_DDY$year < 2013] <- TRUE
template_DDY <- dplyr::filter(template_DDY, !drop)
template_DDY$drop <- FALSE
template_DDY$drop[template_DDY$responder == "Turkey" & template_DDY$year < 1995] <- TRUE
template_DDY$drop[template_DDY$responder == "Liechtenstein" & template_DDY$year < 1991] <- TRUE
template_DDY$drop[template_DDY$responder %in% c("Cyprus", "Czech Republic", "Estonia", "Hungary", "Latvia", "Lithuania", "Malta", "Poland", "Slovakia", "Slovenia") & template_DDY$year < 2004] <- TRUE
template_DDY$drop[template_DDY$responder %in% c("Bulgaria", "Romania") & template_DDY$year < 2007] <- TRUE
template_DDY$drop[template_DDY$responder == "Croatia" & template_DDY$year < 2013] <- TRUE
template_DDY$drop[template_DDY$notifier == template_DDY$responder] <- TRUE
template_DDY <- dplyr::filter(template_DDY, !drop)
template_DDY <- dplyr::select(template_DDY, -drop)

##################################################
# comments
##################################################

# collapse by member state and by year
comments_DDY <- comments %>%
  dplyr::group_by(notification_by, comment_by, start_year) %>%
  dplyr::summarize(
    count_comments = dplyr::n()
  ) %>% dplyr::ungroup()

# rename variable
comments_DDY <- dplyr::rename(comments_DDY, year = start_year)

# merge
comments_DDY <- dplyr::left_join(template_DDY, comments_DDY, by = c("notifier" = "notification_by", "responder" = "comment_by", "year"))

# convert to a tibble
comments_DDY <- dplyr::as_tibble(comments_DDY)

# code zeros
comments_DDY$count_comments[is.na(comments_DDY$count_comments)] <- 0

# merge in entity data
comments_DDY <- dplyr::left_join(comments_DDY, codes, by = c("notifier" = "entity"))

# rename variables
comments_DDY <- dplyr::rename(
  comments_DDY,
  notification_by = notifier,
  notification_by_ID = entity_ID,
  notification_by_code = entity_code
)

# merge in entity data
comments_DDY <- dplyr::left_join(comments_DDY, codes, by = c("responder" = "entity"))

# rename variables
comments_DDY <- dplyr::rename(
  comments_DDY,
  comment_by = responder,
  comment_by_ID = entity_ID,
  comment_by_code = entity_code
)

# arrange
comments_DDY <- dplyr::arrange(comments_DDY, year, comment_by_ID, notification_by_ID)

# key ID
comments_DDY$key_ID <- 1:nrow(comments_DDY)

# select variables
comments_DDY <- dplyr::select(
  comments_DDY,
  key_ID, year, 
  comment_by_ID, comment_by, comment_by_code, 
  notification_by_ID, notification_by, notification_by_code, 
  count_comments
)

# save
save(comments_DDY, file = "data/comments_DDY.RData")

##################################################
# opinions
##################################################

# collapse by member state and by year
opinions_DDY <- opinions %>%
  dplyr::group_by(notification_by, opinion_by, start_year) %>%
  dplyr::summarize(
    count_opinions = dplyr::n()
  ) %>% dplyr::ungroup()

# rename variable
opinions_DDY <- dplyr::rename(opinions_DDY, year = start_year)

# merge
opinions_DDY <- dplyr::left_join(template_DDY, opinions_DDY, by = c("notifier" = "notification_by", "responder" = "opinion_by", "year"))

# convert to a tibble
opinions_DDY <- dplyr::as_tibble(opinions_DDY)

# code zeros
opinions_DDY$count_opinions[is.na(opinions_DDY$count_opinions)] <- 0

# merge in entity data
opinions_DDY <- dplyr::left_join(opinions_DDY, codes, by = c("notifier" = "entity"))

# rename variables
opinions_DDY <- dplyr::rename(
  opinions_DDY,
  notification_by = notifier,
  notification_by_ID = entity_ID,
  notification_by_code = entity_code
)

# merge in entity data
opinions_DDY <- dplyr::left_join(opinions_DDY, codes, by = c("responder" = "entity"))

# rename variables
opinions_DDY <- dplyr::rename(
  opinions_DDY,
  opinion_by = responder,
  opinion_by_ID = entity_ID,
  opinion_by_code = entity_code
)

# arrange
opinions_DDY <- dplyr::arrange(opinions_DDY, year, opinion_by_ID, notification_by_ID)

# key ID
opinions_DDY$key_ID <- 1:nrow(opinions_DDY)

# select variables
opinions_DDY <- dplyr::select(
  opinions_DDY,
  key_ID, year, 
  opinion_by_ID, opinion_by, opinion_by_code, 
  notification_by_ID, notification_by, notification_by_code, 
  count_opinions
)

# save
save(opinions_DDY, file = "data/opinions_DDY.RData")

###########################################################################
# end R script
###########################################################################
