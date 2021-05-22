################################################################################
# Joshua C. Fjelstul, Ph.D.
# eutr R package
################################################################################

# clean workspace
rm(list = ls())

##################################################
# run replication scripts
##################################################

# parse XLS files
# source("replication-code/01_parse_xls.R")
# rm(list = ls())
# input: data-raw/XLS-files/ (hand collected)
# output: data-raw/notifications_raw.RData

# download HTML files
# source("replication-code/02_download_html.R")
# rm(list = ls())
# input: data-raw/notifications-raw.RData
# output: data-raw/HTML-pages/

# parse HTML files
# source("replication-code/03_parse_html.R")
# rm(list = ls())
# input: data-raw/notifications-raw.RData
# input: data-raw/HTML-pages/
# output: data-raw/notifications_raw_metadata.RData

# make notifications data
source("data-raw/code/04_notifications.R")
rm(list = ls())
# input: data-raw/notifications_raw_metadata.RData
# input: data-raw/entity_codes.csv (hand coded)
# output: data/notifications.Rdata
# output: data/notifications_extended.Rdata

# make comments data
source("data-raw/code/05_comments.R")
rm(list = ls())
# input: data/notifications.RData
# input: data-raw/entity_codes.csv (hand coded)
# output: data/comments.RData

# make opinions data
source("data-raw/code/06_opinions.R")
rm(list = ls())
# input: data/notifications.RData
# input: data-raw/entity_codes.csv (hand coded)
# output: data/opinions.RData

# make TS data
source("data-raw/code/07_ts_data.R")
rm(list = ls())
# input: data/notifications.RData
# input: data/comments.RData
# input: data/opinions.RDatA
# output: data/notifications_ts.Rdata
# output: data/comments_ts.Rdata
# output: data/opinions_ts.Rdata

# make CSTS data
source("data-raw/code/08_csts_data.R")
rm(list = ls())
# input: data-raw/entity_codes.csv (hand coded)
# input: data/notifications.RData
# input: data/comments.RData
# input: data/opinions.RData
# output: data/notifications_csts.Rdata
# output: data/comments_csts.Rdata
# output: data/opinions_csts.Rdata

# make DDY data
source("data-raw/code/09_ddy_data.R")
rm(list = ls())
# input: data-raw/entity_codes.csv (hand coded)
# input: data/comments.RData
# input: data/opinions.RData
# output: data/comments_ddy.Rdata
# output: data/opinions_ddy.Rdata

# make network data
source("data-raw/code/10_net_data.R")
rm(list = ls())
# input: data/comments_ddy.RData
# input: data/opinions_ddy.RData
# output: data/comments_net.Rdata
# output: data/opinions_net.Rdata

##################################################
# entity codes
##################################################

# read in codes
entity_codes <- read.csv("data-raw/entity_codes.csv", stringsAsFactors = FALSE)

# add key ID
entity_codes$key_id <- 1:nrow(entity_codes)

# select variables
entity_codes <- dplyr::select(entity_codes, key_id, entity_id, entity, entity_code)

# save as RData
save(entity_codes, file = "data/entity_codes.RData")

##################################################
# codebook
##################################################

# read in data
codebook <- read.csv("data-raw/codebook/codebook.csv", stringsAsFactors = FALSE)

# convert to a tibble
codebook <- dplyr::as_tibble(codebook)

# save
save(codebook, file = "data/codebook.RData")

# documentation
codebookr::document_data(
  path = "R/",
  codebook_file = "data-raw/codebook/codebook.csv",
  markdown_file = "data-raw/codebook/descriptions.txt",
  author = "Joshua C. Fjelstul, Ph.D.",
  package = "eutr"
)

##################################################
# load data
##################################################

# notifications
load("data/notifications.RData")
load("data/notifications_ts.RData")
load("data/notifications_csts.RData")

# comments
load("data/comments.RData")
load("data/comments_ts.RData")
load("data/comments_csts_n.RData")
load("data/comments_csts_s.RData")
load("data/comments_ddy.RData")
load("data/comments_net.RData")

# opinions
load("data/opinions.RData")
load("data/opinions_ts.RData")
load("data/opinions_csts_n.RData")
load("data/opinions_csts_s.RData")
load("data/opinions_ddy.RData")
load("data/opinions_net.RData")

# entity codes
load("data/entity_codes.RData")

# codebook
load("data/codebook.RData")

##################################################
# build
##################################################

# notificatons
write.csv(notifications, "build/eutr_notifications.csv", row.names = FALSE)
write.csv(notifications_ts, "build/eutr_notifications_ts.csv", row.names = FALSE)
write.csv(notifications_csts, "build/eutr_notifications_csts.csv", row.names = FALSE)

# comments
write.csv(comments, "build/eutr_comments.csv", row.names = FALSE)
write.csv(comments_ts, "build/eutr_comments_ts.csv", row.names = FALSE)
write.csv(comments_csts_n, "build/eutr_comments_csts_n.csv", row.names = FALSE)
write.csv(comments_csts_s, "build/eutr_comments_csts_s.csv", row.names = FALSE)
write.csv(comments_ddy, "build/eutr_comments_ddy.csv", row.names = FALSE)
write.csv(comments_net, "build/eutr_comments_net.csv", row.names = FALSE)

# opinions
write.csv(opinions, "build/eutr_opinions.csv", row.names = FALSE)
write.csv(opinions_ts, "build/eutr_opinions_ts.csv", row.names = FALSE)
write.csv(opinions_csts_n, "build/eutr_opinions_csts_n.csv", row.names = FALSE)
write.csv(opinions_csts_s, "build/eutr_opinions_csts_s.csv", row.names = FALSE)
write.csv(opinions_ddy, "build/eutr_opinions_ddy.csv", row.names = FALSE)
write.csv(opinions_net, "build/eutr_opinions_net.csv", row.names = FALSE)

# entity codes
write.csv(entity_codes, "build/eutr_entity_codes.csv", row.names = FALSE)

# codebook
write.csv(codebook, "build/eutr_codebook.csv", row.names = FALSE)

##################################################
# server
##################################################

# notificatons
write.csv(notifications, "server/eutr_notifications.csv", row.names = FALSE, na = "\\N")
write.csv(notifications_ts, "server/eutr_notifications_ts.csv", row.names = FALSE, na = "\\N")
write.csv(notifications_csts, "server/eutr_notifications_csts.csv", row.names = FALSE, na = "\\N")

# comments
write.csv(comments, "server/eutr_comments.csv", row.names = FALSE, na = "\\N")
write.csv(comments_ts, "server/eutr_comments_ts.csv", row.names = FALSE, na = "\\N")
write.csv(comments_csts_n, "server/eutr_comments_csts_n.csv", row.names = FALSE, na = "\\N")
write.csv(comments_csts_s, "server/eutr_comments_csts_s.csv", row.names = FALSE, na = "\\N")
write.csv(comments_ddy, "server/eutr_comments_ddy.csv", row.names = FALSE, na = "\\N")
write.csv(comments_net, "server/eutr_comments_net.csv", row.names = FALSE, na = "\\N")

# opinions
write.csv(opinions, "server/eutr_opinions.csv", row.names = FALSE, na = "\\N")
write.csv(opinions_ts, "server/eutr_opinions_ts.csv", row.names = FALSE, na = "\\N")
write.csv(opinions_csts_n, "server/eutr_opinions_csts_n.csv", row.names = FALSE, na = "\\N")
write.csv(opinions_csts_s, "server/eutr_opinions_csts_s.csv", row.names = FALSE, na = "\\N")
write.csv(opinions_ddy, "server/eutr_opinions_ddy.csv", row.names = FALSE, na = "\\N")
write.csv(opinions_net, "server/eutr_opinions_net.csv", row.names = FALSE, na = "\\N")

# entity codes
write.csv(entity_codes, "server/eutr_entity_codes.csv", row.names = FALSE, na = "\\N")

# codebook
write.csv(codebook, "server/eutr_codebook.csv", row.names = FALSE, na = "\\N")

################################################################################
# end R script
################################################################################
