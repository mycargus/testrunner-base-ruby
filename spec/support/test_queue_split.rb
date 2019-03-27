# frozen_string_literal: true

# https://github.com/tmm1/test-queue

# Set to 'true' to split tests up by example rather than example group
ENV['TEST_QUEUE_SPLIT_GROUPS'] = 'false'

# Record test run stats to optimize subsequent test runs.
#
# Changing this value will affect continuous integration builds!
ENV['TEST_QUEUE_STATS'] = 'tmp/.test_queue_stats'

# Set to '1' to show results as they are available
ENV['TEST_QUEUE_VERBOSE'] = '0'
