

import urllib
import json

repos = json.load(urllib.urlopen("https://api.github.com/users/shinken-monitoring/repos?per_page=1000"))

repos = [repo for repo in repos if repo['name'].startswith("mod")]

for repo in repos:
    print repo['ssh_url']

