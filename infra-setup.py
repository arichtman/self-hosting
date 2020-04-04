from hcloud import Client
from hcloud.server_types.domain import ServerType
from hcloud.images.domain import Image
from hcloud.ssh_keys.domain import SSHKey
import pprint
import json

with open('secrets.json') as json_file:
    data = json.load(json_file)

token = data['hetzner']['apiToken']
data['hetzner']['ssh']['privateKey']

client = Client(token)
# TODO: use API to upload public key for SSH
response = client.servers.create(
    name="my-server", server_type=ServerType(name="cx11"), image=Image(name="centos-8"))
server = response.server
print(server)
print("Root Password: " + response.root_password)
