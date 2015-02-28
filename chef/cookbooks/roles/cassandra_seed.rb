name		'cassandra_seed'
description	'A role for running Apache Cassandra'

run_list *%w[
  role[cassandra]
  role[cassandra::seed]
]
