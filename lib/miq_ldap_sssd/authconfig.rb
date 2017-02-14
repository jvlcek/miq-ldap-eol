=begin
authconfig \
  --enablesssd \
  --enablesssdauth \
  --enablelocauthorize \
  --enableldap \
  --enableldapauth \
  --ldapserver=ldaps://joev-openldap.jvlcek.redhat.com:636 \
  --disableldaptls \
  --ldapbasedn=dc=jvlcek,dc=com \
  --enablerfc2307bis \
  --enablecachecreds \
  --update
=end
