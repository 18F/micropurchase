# Note: as a practice, only envars used in more than one file should be
# mapped to a method. It prevents shotgun surgery in the event of changes
# to storage location.

Credentials.map(:data_dot_gov_api_key,  to: ['data-dot-gov', 'api_key'])
Credentials.map(:c2_host,               to: ['c2_host'])
