#!/usr/bin/env python
# Reflects the requests from HTTP methods GET, POST, PUT, and DELETE
# Written by Nathan Hamiel (2010)

from BaseHTTPServer import HTTPServer, BaseHTTPRequestHandler
from optparse import OptionParser
import urlparse, os
import requests
import shutil
import json
import pickle
from pybitcoin import BitcoinPublicKey
global dump
global tmpmap
global balmap
tmpmap={}
balmap={}

# for testing only
balmap["1BmQQ36gKbvaYFfdEn5hAMUE6UgxUh1fg1"]=10000.34205
if os.path.isfile("pickled_balmap.dat"): 
    output = open('pickled_balmap.dat', 'rb')
    balmap = pickle.load(output)    # 'obj_dict' is a dict object
    output = open('pickled_tmpmap.dat', 'rb')
    tmpmap = pickle.load(output)    # 'obj_dict' is a dict object
else:
    if os.path.isfile("genesis.json") == False: 
        print "Downloading Genesis Block"
        download_file()
        save_file()
    json_file="genesis.json"
    json_data=open(json_file)
    data = json.load(json_data)
    for x in data:
                try:
                        addy = ""
                        pub = str(x["owner_pubkey"])
                        pbl = BitcoinPublicKey(pub)
                        tmpmap[pub] = pbl.address()
                        addy = tmpmap[pub];
                        if addy == givenadd:
                            bal = float(x["mir_amount"])
                        balmap[addy] = float(x["mir_amount"])

                except:
                        pass

                output = open('pickled_tmpmap.dat', 'wb+')
                pickle.dump(tmpmap, output)
                output.close()
                output = open('pickled_balmap.dat', 'wb+')
                pickle.dump(balmap, output)
                output.close()


def download_file():
    global dump
    url = "https://raw.githubusercontent.com/elastic-project/genesis-block/master/genesis-block.json"
    file = requests.get(url, stream=True)
    dump = file.content

def save_file():
    global dump
    obj = open('genesis.json', 'w+')
    obj.write(dump)
    obj.close

class RequestHandler(BaseHTTPRequestHandler):
    
    def do_GET(self):
        global tmpmap
        global balmap

        qs = {}
        path = self.path
        if "favicon" in path:
            self.send_response(200)
            return
        if '?' in path:
            path, tmp = path.split('?', 1)
            qs = urlparse.parse_qs(tmp)
        request_path = self.path
        self.send_response(200)
        self.send_header("Content-type", "text/plain")
        self.end_headers()
        givenadd = str(qs["address"][0])
        print "Asking for",givenadd
        if "address" not in qs:
            self.wfile.write("0")
        else:
            bal = 0.0
            if givenadd in balmap:
                bal = balmap[givenadd]
            self.wfile.write( "%.6f" % abs(bal))
       
        
                
def main():
    port = 8080
    print('Listening on localhost:%s' % port)
    server = HTTPServer(('', port), RequestHandler)
    server.serve_forever()

        
if __name__ == "__main__":
    parser = OptionParser()
    parser.usage = ("Creates an http-server that will echo out XEL balances\n"
                    "Run:\n\n"
                    "   reflect")
    (options, args) = parser.parse_args()
    
    main()