##############################################
#
# izeni-redirect pillar
#
##############################################

project_name: izeni-redirect

fqdn: izeni.com

letsencrypt:
  config: |
    server = https://acme-v01.api.letsencrypt.org/directory
    email = kcole@izeni.com
    authenticator = webroot
    webroot-path = /opt/webroot/
    agree-tos = True
    renew-by-default = True
  domainsets:
    www:
      - izeni.com
      - www.izeni.com
