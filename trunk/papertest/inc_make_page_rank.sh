set -x

source ./papertest/abbreviation.sh

# If 'full' is defined, whether 'share' or not makes no sence because there is only one array in message content.
#
# If 'rolling' is defined, theoratically speaking, whether 'share' or not makes little difference, so we eliminate one of them.

BUILD_MARK=origin                       LAMBDA_DEBUG_FLAGS=${pf},${st}                               USER_PATH=page_rank USER_FILE= make build
BUILD_MARK=origin-share                 LAMBDA_DEBUG_FLAGS=${pf},${st},${sh}                         USER_PATH=page_rank USER_FILE= make build
BUILD_MARK=origin-rolling               LAMBDA_DEBUG_FLAGS=${pf},${st},${ro}                         USER_PATH=page_rank USER_FILE= make build
# BUILD_MARK=origin-full                  LAMBDA_DEBUG_FLAGS=${pf},${st},${fu}                         USER_PATH=page_rank USER_FILE= make build
BUILD_MARK=origin-rolling-full          LAMBDA_DEBUG_FLAGS=${pf},${st},${ro},${fu}                   USER_PATH=page_rank USER_FILE= make build

# BUILD_MARK=sorted                       LAMBDA_DEBUG_FLAGS=${pf},${st},${so}                         USER_PATH=page_rank USER_FILE= make build
# BUILD_MARK=sorted-share                 LAMBDA_DEBUG_FLAGS=${pf},${st},${so},${sh}                   USER_PATH=page_rank USER_FILE= make build
BUILD_MARK=sorted-rolling               LAMBDA_DEBUG_FLAGS=${pf},${st},${so},${ro}                   USER_PATH=page_rank USER_FILE= make build
# BUILD_MARK=sorted-full                  LAMBDA_DEBUG_FLAGS=${pf},${st},${so},${fu}                   USER_PATH=page_rank USER_FILE= make build
# BUILD_MARK=sorted-rolling-full          LAMBDA_DEBUG_FLAGS=${pf},${st},${so},${ro},${fu}             USER_PATH=page_rank USER_FILE= make build

# BUILD_MARK=coalesced                    LAMBDA_DEBUG_FLAGS=${pf},${st},${so},${co}                   USER_PATH=page_rank USER_FILE= make build
# BUILD_MARK=coalesced-share              LAMBDA_DEBUG_FLAGS=${pf},${st},${so},${co},${sh}             USER_PATH=page_rank USER_FILE= make build
# BUILD_MARK=coalesced-rolling            LAMBDA_DEBUG_FLAGS=${pf},${st},${so},${co},${ro}             USER_PATH=page_rank USER_FILE= make build
# BUILD_MARK=coalesced-full               LAMBDA_DEBUG_FLAGS=${pf},${st},${so},${co},${fu}             USER_PATH=page_rank USER_FILE= make build
BUILD_MARK=coalesced-rolling-full       LAMBDA_DEBUG_FLAGS=${pf},${st},${so},${co},${ro},${fu}       USER_PATH=page_rank USER_FILE= make build

