import sys                                                                                        
sys.path.append('/QOpenSys/QIBM/ProdData/OPS/Python2.7/lib/python2.7/site-packages')              
                                                                                                  
import warnings                                                                                   
warnings.filterwarnings("ignore")                                                                 
                                                                                                  
import sys                                                                                        
import time                                                                                       
start_time = time.time()                                                                          
import base64                                                                                     
from datetime import datetime                                                                     
from elasticsearch import Elasticsearch                                                           
                                                                                                  
user = base64.b64decode("ZWxhc3RpYw==").decode("utf-8")                                           
passwd = base64.b64decode("SE9uaEQ2Ykh6TkMzdW9yVkdNVHQwUVZs").decode("utf-8")                     
                                                                                                  
latA=sys.argv[1]                                                                                  
lonA=sys.argv[2]    
latB=sys.argv[3]                                                                                                       
lonB=sys.argv[4]                                                                                                       
                                                                                                                       
key=str(latA) + "|" + str(lonA) + "|" + str(latB) + "|" + str(lonB)     

es = Elasticsearch(cloud_id="swiftp01:d2VzdHVzMi5henVyZS5lbGFzdGljLWNsb3VkLmNvbTo5MjQzJDZiMTM0ZmJkOGU3NTQ4OWFiYmIwZDgyYmRmMWQ5M2VjJDA5ZGRjMDM0ODU4YTRkNjM5YjMzZWExZGM1OTkwZTgz",    http_auth=(user,passwd))                                                                                                                            

resp = es.search(                             
index="knx.georoute.stg",                     
body={"query":{                               
            "bool": {                         
                "filter": [                   
                    { "match": { "_id": key }}    
                ]                             
            }                                 
        }                                         
    }                                             
)        

def map_row(point, mins):                                                              
    textFormat = "lat: {}, lng: {}, mins: {}"                                          
    print (textFormat.format(point[0], point[1], mins))                                
                                                                                       
def map_response(coordinates, path_mins):                                              
    for index, point in enumerate(coordinates):                                        
        map_row(point, path_mins[index])                                               
                                                                                       
for row in resp['hits']['hits']:                                                       
    map_response(row["_source"]["route"]["coordinates"], row["_source"]["path_mins"])                                       
