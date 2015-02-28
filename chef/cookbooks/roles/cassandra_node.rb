name		'cassandra_node'
description	'A role for running Apache Cassandra'

run_list *%w[
  role[cassandra]
  role[cassandra::node]
]
