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
# output: "data-raw/notifications-raw.RData"

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
# output: "data/notifications_EY.Rdata"

# make comments data
source("replication-code/5-comments.R")
rm(list = ls())
# input: "data/notifications.RData"
# input: "data-raw/entity-codes.csv" (hand coded)
# output: "data/comments.RData"
# output: "data/comments_EY.RData"
# output: "data/comments_DDY.RData"
# output: "data/comments_network.RData"

# make opinions data
source("replication-code/6-opinions.R")
rm(list = ls())
# input: "data/notifications.RData"
# input: "data-raw/entity-codes.csv" (hand coded)
# output: "data/opinions.RData"
# output: "data/opinions_EY.RData"
# output: "data/opinions_DDY.RData"
# output: "data/opinions_network.RData"

##################################################
# load data
##################################################

# load data
load("data/notifications.RData")
load("data/notifications_extended.RData")
load("data/notifications_EY.RData")
load("data/comments.RData")
load("data/comments_EY.RData")
load("data/comments_DDY.RData")
load("data/comments_network.RData")
load("data/opinions.RData")
load("data/opinions_EY.RData")
load("data/opinions_DDY.RData")
load("data/opinions_network.RData")

##################################################
# write data
##################################################

# write CSV files
write.csv(notifications, "build/EU-TRIS-notifications.csv", row.names = FALSE)
write.csv(notifications_extended, "build/EU-TRIS-notifications-extended.csv", row.names = FALSE)
write.csv(notifications_EY, "build/EU-TRIS-notifications-EY.csv", row.names = FALSE)
write.csv(comments, "build/EU-TRIS-comments.csv", row.names = FALSE)
write.csv(comments_EY, "build/EU-TRIS-comments-EY.csv", row.names = FALSE)
write.csv(comments_DDY, "build/EU-TRIS-comments-DDY.csv", row.names = FALSE)
write.csv(comments_network, "build/EU-TRIS-comments-network.csv", row.names = FALSE)
write.csv(opinions, "build/EU-TRIS-opinions.csv", row.names = FALSE)
write.csv(opinions_EY, "build/EU-TRIS-opinions-EY.csv", row.names = FALSE)
write.csv(opinions_DDY, "build/EU-TRIS-opinions-DDY.csv", row.names = FALSE)
write.csv(opinions_network, "build/EU-TRIS-opinions-network.csv", row.names = FALSE)

###########################################################################
# end R script
###########################################################################
