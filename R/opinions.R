###########################################################################
# Joshua C. Fjelstul, Ph.D.
# euaid R package
###########################################################################

#' Opinions on TRIS Notifications
#'
#' A dataset of detailed opinions submitted by the European Commission and EU
#' member states in response to notifications from member states about proposed
#' technical regulations as part of the 2015/1535 procedure.
#'
#' @docType data
#'
#' @usage opinions
#'
#' @format A tibble with 9 variables and 4,657 observations:
#' \describe{
#'
#' \item{\code{key_ID}}{Numeric. An ID number that uniquely identifies each
#' observation.}
#'
#' \item{\code{notification_ID}}{String. An ID number that uniquely identifies
#' each notification in the format \code{TRIS:####:####:XX:N}, where the first
#' set of digits is the year the proposed technical regulation was notified, the
#' second set of digits is the number of the notification, \code{XX} is a
#' 2-character code for the member state or third-party country that notified
#' the proposed technical regulation, and \code{N} is a 1-character code
#' indicating a notification.}
#'
#' \item{\code{notification_by}}{String. The member state or third-party country
#' that notified the proposed technical regulation.}
#'
#' \item{\code{start_date}}{Date. The date the notification was received by the
#' Commission in the format \code{YYYY-MM-DD}.}
#'
#' \item{\code{start_year}}{Numeric. The year the notification was received by
#' the Commission.}
#'
#' \item{\code{end_date}}{Date. The date the 2015/1535 procedure was concluded
#' in the format \code{YYYY-MM-DD}.}
#'
#' \item{\code{end_year}}{Numeric. The year the 2015/1535 procedure was
#' concluded.}
#'
#' \item{\code{opinion_ID}}{String. An ID number that uniquely identifies each
#' opinion in the format \code{TRIS:####:####:XX:O:YY}, where the first set of
#' digits is the year the proposed technical regulation was notified, the second
#' set of digits is the number of the notification, \code{XX} is a 2-character
#' code for the member state or third-party country that notified the proposed
#' technical regulation, \code{O} is a 1-character code indicating an opinion
#' (as opposed to a comment), and \code{YY} is a 2-character code for the EU
#' member state that submitted the opinion. Note that \code{YY} can also be
#' \code{EC} for the European Commission.}
#'
#' \item{\code{comment_by}}{String. The name of the entity that submitted the
#' opinion. Either the Commission or the name of an EU member state.}
#'
#' }
#'
"opinions"

###########################################################################
# end R script
###########################################################################
