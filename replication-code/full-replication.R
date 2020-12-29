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

# make opinions data
source("replication-code/7-responses.R")
rm(list = ls())
# input: "data/comments.RData"
# input: "data/opinions.RData"
# output: "data/responses.RData"

# make entity-year data
source("replication-code/8-entity-year-data.R")
rm(list = ls())
# input: "data-raw/entity-codes.csv" (hand coded)
# input: "data/notifications.RData"
# input: "data/comments.RData"
# input: "data/opinions.RData"
# output: "data/notifications_EY.Rdata"
# output: "data/responses_EY.Rdata"
# output: "data/responses_EY_tidy.Rdata"
# output: "data/comments_EY.Rdata"
# output: "data/opinions_EY.Rdata"

# make directed dyad-year data
source("replication-code/9-directed-dyad-year-data.R")
rm(list = ls())
# input: "data-raw/entity-codes.csv" (hand coded)
# input: "data/comments.RData"
# input: "data/opinions.RData"
# output: "data/responses_DDY.Rdata"
# output: "data/responses_DDY_tidy.Rdata"
# output: "data/comments_DDY.Rdata"
# output: "data/opinions_DDY.Rdata"

# make network data
source("replication-code/10-network-data.R")
rm(list = ls())
# input: "data/comments_DDY.RData"
# input: "data/opinions_DDY.RData"
# input: "data/responses_DDY_tidy.RData"
# output: "data/responses_network.Rdata"
# output: "data/comments_network.Rdata"
# output: "data/opinions_network.Rdata"

##################################################
# load data
##################################################

# notifications
load("data/notifications.RData")
load("data/notifications_extended.RData")
load("data/notifications_EY.RData")

# responses
load("data/responses.RData")
load("data/responses_EY.RData")
load("data/responses_EY_tidy.RData")
load("data/responses_DDY.RData")
load("data/responses_DDY_tidy.RData")
load("data/responses_network.RData")

# comments
load("data/comments.RData")
load("data/comments_EY.RData")
load("data/comments_DDY.RData")
load("data/comments_network.RData")

# opinions
load("data/opinions.RData")
load("data/opinions_EY.RData")
load("data/opinions_DDY.RData")
load("data/opinions_network.RData")

##################################################
# write data
##################################################

# notificatons
write.csv(notifications, "build/EUTR-notifications.csv", row.names = FALSE)
write.csv(notifications_extended, "build/EUTR-notifications-extended.csv", row.names = FALSE)
write.csv(notifications_EY, "build/EUTR-notifications-EY.csv", row.names = FALSE)

# responses
write.csv(responses, "build/EUTR-responses.csv", row.names = FALSE)
write.csv(responses_EY, "build/EUTR-responses-EY.csv", row.names = FALSE)
write.csv(responses_EY_tidy, "build/EUTR-responses-EY-tidy.csv", row.names = FALSE)
write.csv(responses_DDY, "build/EUTR-responses-DDY.csv", row.names = FALSE)
write.csv(responses_DDY_tidy, "build/EUTR-responses-DDY-tidy.csv", row.names = FALSE)
write.csv(responses_network, "build/EUTR-responses-network.csv", row.names = FALSE)

# comments
write.csv(comments, "build/EUTR-comments.csv", row.names = FALSE)
write.csv(comments_EY, "build/EUTR-comments-EY.csv", row.names = FALSE)
write.csv(comments_DDY, "build/EUTR-comments-DDY.csv", row.names = FALSE)
write.csv(comments_network, "build/EUTR-comments-network.csv", row.names = FALSE)

# opinions
write.csv(opinions, "build/EUTR-opinions.csv", row.names = FALSE)
write.csv(opinions_EY, "build/EUTR-opinions-EY.csv", row.names = FALSE)
write.csv(opinions_DDY, "build/EUTR-opinions-DDY.csv", row.names = FALSE)
write.csv(opinions_network, "build/EUTR-opinions-network.csv", row.names = FALSE)

###########################################################################
# end R script
###########################################################################
