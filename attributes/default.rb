node.default['apache2']['default_site'] = false
node.default['okb']['legacy']['server_name'] = 'www.1000bulbs.com'
node.default['okb']['legacy']['server_aliases'] = ['1000bulbs.com']
node.default['okb']['legacy']['document_root'] = '/var/apps/1000bulbs.com/current/public_html'

node.default['okb']['legacy']['strangler_url'] = 'https://strangler.1000bulbs.com/fil'
node.default['okb']['legacy']['suggestions_url'] = 'https://eden.1000bulbs.com/api/suggestions'
node.default['okb']['legacy']['static_url'] = 'https://static.1000bulbs.com'

node.default['okb']['legacy']['php']['memory_limit']       = '128M'
node.default['okb']['legacy']['php']['max_execution_time'] = '30'