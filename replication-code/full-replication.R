###########################################################################
# Joshua C. Fjelstul, Ph.D.
# eutris R package
###########################################################################

# clean workspace
rm(list = ls())

##################################################
# run replication scripts
##################################################

# parse XLS files
# source("replication-code/1-parse-XLS.R")
# rm(list = ls())
# input: "data-raw/XLS-files/" (hand collected)
# output: "data-raw/notifications_raw.RData"

# download HTML files
# source("replication-code/2-download-HTML.R")
# rm(list = ls())
# input: "data-raw/notifications-raw.RData"
# output: "data-raw/HTML-pages/"

# parse HTML files
# source("replication-code/3-parse-HTML.R")
# rm(list = ls())
# input: "data-raw/notifications-raw.RData"
# input: "data-raw/HTML-pages/"
# output: "data-raw/notifications_raw_metadata.RData"

# make notifications data
source("replication-code/4-notifications.R")
rm(list = ls())
# input: "data/notifications_raw_metadata.RData"
# input: "data-raw/entity-codes.csv" (hand coded)
# output: "data/notifications.Rdata"
# output: "data/notifications_extended.Rdata"

# make comments data
source("replication-code/5-comments.R")
rm(list = ls())
# input: "data/notifications.RData"
# input: "data-raw/entity-codes.csv" (hand coded)
# output: "data/comments.RData"

# make opinions data
source("replication-code/6-opinions.R")
rm(list = ls())
# input: "data/notifications.RData"
# input: "data-raw/entity-codes.csv" (hand coded)
# output: "data/opinions.RData"

# make TS data
source("replication-code/7-TS-data.R")
rm(list = ls())
# input: "data/notifications.RData"
# input: "data/comments.RData"
# input: "data/opinions.RData"
# output: "data/notifications_TS.Rdata"
# output: "data/comments_TS.Rdata"
# output: "data/opinions_TS.Rdata"

# make CSTS data
source("replication-code/8-CSTS-data.R")
rm(list = ls())
# input: "data-raw/entity-codes.csv" (hand coded)
# input: "data/notifications.RData"
# input: "data/comments.RData"
# input: "data/opinions.RData"
# output: "data/notifications_EY.Rdata"
# output: "data/comments_CSTS.Rdata"
# output: "data/opinions_CSTS.Rdata"

# make DDY data
source("replication-code/9-DDY-data.R")
rm(list = ls())
# input: "data-raw/entity-codes.csv" (hand coded)
# input: "data/comments.RData"
# input: "data/opinions.RData"
# output: "data/comments_DDY.Rdata"
# output: "data/opinions_DDY.Rdata"

# make network data
source("replication-code/10-network-data.R")
rm(list = ls())
# input: "data/comments_DDY.RData"
# input: "data/opinions_DDY.RData"
# output: "data/comments_network.Rdata"
# output: "data/opinions_network.Rdata"

##################################################
# entity codes
##################################################

# read in codes
entity_codes <- read.csv("data-raw/entity-codes.csv", stringsAsFactors = FALSE)

# add key ID
entity_codes$key_ID <- 1:nrow(entity_codes)

# select variables
entity_codes <- dplyr::select(entity_codes, key_ID, entity_ID, entity, entity_code)

# save as RData
save(entity_codes, file = "data/entity_codes.RData")

# save as CSV
write.csv(entity_codes, "build/EUTR-entity-codes.csv", row.names = FALSE)

# save as CSV for database
write.csv(entity_codes, "build-database/EUTR-entity-codes.csv", row.names = FALSE, quote = TRUE, na = "\\N")

##################################################
# load data
##################################################

# notifications
load("data/notifications.RData")
load("data/notifications_extended.RData")
load("data/notifications_TS.RData")
load("data/notifications_CSTS.RData")

# comments
load("data/comments.RData")
load("data/comments_TS.RData")
load("data/comments_CSTS.RData")
load("data/comments_DDY.RData")
load("data/comments_network.RData")

# opinions
load("data/opinions.RData")
load("data/opinions_TS.RData")
load("data/opinions_CSTS.RData")
load("data/opinions_DDY.RData")
load("data/opinions_network.RData")

##################################################
# write data
##################################################

# notificatons
write.csv(notifications, "build/EUTR-notifications.csv", row.names = FALSE)
write.csv(notifications_extended, "build/EUTR-notifications-extended.csv", row.names = FALSE)
write.csv(notifications_TS, "build/EUTR-notifications-TS.csv", row.names = FALSE)
write.csv(notifications_CSTS, "build/EUTR-notifications-CSTS.csv", row.names = FALSE)

# comments
write.csv(comments, "build/EUTR-comments.csv", row.names = FALSE)
write.csv(comments_TS, "build/EUTR-comments-TS.csv", row.names = FALSE)
write.csv(comments_CSTS, "build/EUTR-comments-CSTS.csv", row.names = FALSE)
write.csv(comments_DDY, "build/EUTR-comments-DDY.csv", row.names = FALSE)
write.csv(comments_network, "build/EUTR-comments-network.csv", row.names = FALSE)

# opinions
write.csv(opinions, "build/EUTR-opinions.csv", row.names = FALSE)
write.csv(opinions_TS, "build/EUTR-opinions-TS.csv", row.names = FALSE)
write.csv(opinions_CSTS, "build/EUTR-opinions-CSTS.csv", row.names = FALSE)
write.csv(opinions_DDY, "build/EUTR-opinions-DDY.csv", row.names = FALSE)
write.csv(opinions_network, "build/EUTR-opinions-network.csv", row.names = FALSE)

##################################################
# write data
##################################################

# notificatons
write.csv(notifications, "build-database/EUTR-notifications.csv", row.names = FALSE, quote = TRUE, na = "\\N")
write.csv(notifications_extended, "build-database/EUTR-notifications-extended.csv", row.names = FALSE, quote = TRUE, na = "\\N")
write.csv(notifications_TS, "build-database/EUTR-notifications-TS.csv", row.names = FALSE, quote = TRUE, na = "\\N")
write.csv(notifications_CSTS, "build-database/EUTR-notifications-CSTS.csv", row.names = FALSE, quote = TRUE, na = "\\N")

# comments
write.csv(comments, "build-database/EUTR-comments.csv", row.names = FALSE, quote = TRUE, na = "\\N")
write.csv(comments_TS, "build-database/EUTR-comments-TS.csv", row.names = FALSE, quote = TRUE, na = "\\N")
write.csv(comments_CSTS, "build-database/EUTR-comments-CSTS.csv", row.names = FALSE, quote = TRUE, na = "\\N")
write.csv(comments_DDY, "build-database/EUTR-comments-DDY.csv", row.names = FALSE, quote = TRUE, na = "\\N")
write.csv(comments_network, "build-database/EUTR-comments-network.csv", row.names = FALSE, quote = TRUE, na = "\\N")

# opinions
write.csv(opinions, "build-database/EUTR-opinions.csv", row.names = FALSE, quote = TRUE, na = "\\N")
write.csv(opinions_TS, "build-database/EUTR-opinions-TS.csv", row.names = FALSE, quote = TRUE, na = "\\N")
write.csv(opinions_CSTS, "build-database/EUTR-opinions-CSTS.csv", row.names = FALSE, quote = TRUE, na = "\\N")
write.csv(opinions_DDY, "build-database/EUTR-opinions-DDY.csv", row.names = FALSE, quote = TRUE, na = "\\N")
write.csv(opinions_network, "build-database/EUTR-opinions-network.csv", row.names = FALSE, quote = TRUE, na = "\\N")

###########################################################################
# end R script
###########################################################################
