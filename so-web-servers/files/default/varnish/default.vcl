# This is a basic VCL configuration file for varnish.  See the vcl(7)
# man page for details on VCL syntax and semantics.
# 
# Default backend definition.  Set this to point to your content
# server.
# 
backend default {
	.host = "67.203.70.83";
	.port = "8080";
	.connect_timeout = 10s;
    	.first_byte_timeout = 30s;
}

import std;

sub vcl_recv {

#don't allow bots to crawl inventory search pages - See Mohammad before changing
#        #exceptions are when it ends with .html or when the only parameters are index parameters
if ( req.http.user-agent ~ "bot" && (req.url ~ "(new\.html|pre-owned\.html|certified\.html|used\.html)" ) && !(req.url ~ "html$") #there are no parameters 
   && !(req.url ~ "\?start_index")) # the only parameter is index
   {
     error 403 "Do not index";
   }

                                                                                                                


if (req.url ~ "phpMyAdmin|phpmyadmin|joomla|\.cgi|\.pl|\.ini|\.sql|\.php\~|\.bak|\.old"){
                error 404 "Not Found";
        }

if (req.request != "GET" && req.request != "HEAD" && req.request != "POST" ){
                error 405 "Method Not Allowed";
        }

if (req.request == "POST") {
                return (pass);
        }

if (req.url ~ "config|email-parser|admin|utm|gglt|cpmt|xut") {
                #std.log("bypass cache because url is " req.url);
                return(pass);
        }

if (req.http.Authenticate) {
#                log "bypass cache for http auth";
                return(pass);
        }

if (req.http.user-agent ~ "iP(hone|od|ad)|BlackBerry|Android") {
#                log "bypass cache for mobile user";
                return(pass);
        }
 if (req.request == "GET" && req.url ~ "\.(gif|jpg|swf|css|js|png|jpg|jpeg|gif|png|tiff|tif|svg|swf|ico|css|js|vsd|doc|ppt|pps|xls|pdf|mp3|mp4|m4a|mov|avi|wmv)$") {
                unset req.http.cookie;
                unset req.http.Set-Cookie;
                return (lookup);
        }

if (req.http.cookie) {
	set req.http.cookie = regsuball(req.http.cookie, "(^|; ) *__utm.=[^;]+;? *", "\1");
if (req.http.cookie == "") {
               remove req.http.cookie;
        }
    }

if (req.http.cookie ~ "so_mf_form_displayed"){
        return(pass);
        }

if (req.http.cookie !~ "zip" && req.http.cookie !~ "sort" && req.http.cookie !~ "listingStyle" ){
        unset req.http.cookie;
        unset req.http.Set-Cookie;
        return(lookup);
    }

if(req.http.cookie ~ "PHPSESSID"){
#       log "bypass cache for sessioned page";
        return(pass);
    }

return (lookup);
}

sub vcl_fetch {

set req.grace = 6h;

set beresp.ttl = 15m;

if (req.request == "GET" && req.url ~ "specials"){
          set beresp.ttl = 15m;
        }

if (req.request == "GET" && req.url ~ "\.(gif|jpg|swf|css|js|png|jpg|jpeg|gif|png|tiff|tif|svg|swf|ico|css|js|vsd|doc|ppt|pps|xls|pdf|mp3|mp4|m4a|mov|avi|wmv)$") {
          set beresp.ttl = 60m;
        }

#if (beresp.ttl > 0s) {
#          set req.http.X-Cacheable = "Not-Cacheable";
#          return (pass);
#        }

if(beresp.status == 404 || beresp.status == 500) {
          set beresp.http.Cache-Control = "max-age=30";
          set beresp.ttl = 30s;
          set beresp.grace = 30s;
        }


return (deliver);



}

sub vcl_deliver {

set resp.http.X-Cache-Host = server.hostname;

if (obj.hits > 0) {
 set resp.http.X-Cache = "HIT";
        set resp.http.X-Cache-Hits = obj.hits;
    } else {
        set resp.http.X-Cache = "MISS";
    }

}


# 
# Below is a commented-out copy of the default VCL logic.  If you
# redefine any of these subroutines, the built-in logic will be
# appended to your code.
# sub vcl_recv {
#     if (req.restarts == 0) {
# 	if (req.http.x-forwarded-for) {
# 	    set req.http.X-Forwarded-For =
# 		req.http.X-Forwarded-For + ", " + client.ip;
# 	} else {
# 	    set req.http.X-Forwarded-For = client.ip;
# 	}
#     }
#     if (req.request != "GET" &&
#       req.request != "HEAD" &&
#       req.request != "PUT" &&
#       req.request != "POST" &&
#       req.request != "TRACE" &&
#       req.request != "OPTIONS" &&
#       req.request != "DELETE") {
#         /* Non-RFC2616 or CONNECT which is weird. */
#         return (pipe);
#     }
#     if (req.request != "GET" && req.request != "HEAD") {
#         /* We only deal with GET and HEAD by default */
#         return (pass);
#     }
#     if (req.http.Authorization || req.http.Cookie) {
#         /* Not cacheable by default */
#         return (pass);
#     }
#     return (lookup);
# }
# 
# sub vcl_pipe {
#     # Note that only the first request to the backend will have
#     # X-Forwarded-For set.  If you use X-Forwarded-For and want to
#     # have it set for all requests, make sure to have:
#     # set bereq.http.connection = "close";
#     # here.  It is not set by default as it might break some broken web
#     # applications, like IIS with NTLM authentication.
#     return (pipe);
# }
# 
# sub vcl_pass {
#     return (pass);
# }
# 
# sub vcl_hash {
#     hash_data(req.url);
#     if (req.http.host) {
#         hash_data(req.http.host);
#     } else {
#         hash_data(server.ip);
#     }
#     return (hash);
# }
# 
# sub vcl_hit {
#     return (deliver);
# }
# 
# sub vcl_miss {
#     return (fetch);
# }
# 
# sub vcl_fetch {
#     if (beresp.ttl <= 0s ||
#         beresp.http.Set-Cookie ||
#         beresp.http.Vary == "*") {
# 		/*
# 		 * Mark as "Hit-For-Pass" for the next 2 minutes
# 		 */
# 		set beresp.ttl = 120 s;
# 		return (hit_for_pass);
#     }
#     return (deliver);
# }
# 
# sub vcl_deliver {
#     return (deliver);
# }
# 
# sub vcl_error {
#     set obj.http.Content-Type = "text/html; charset=utf-8";
#     set obj.http.Retry-After = "5";
#     synthetic {"
# <?xml version="1.0" encoding="utf-8"?>
# <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
#  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
# <html>
#   <head>
#     <title>"} + obj.status + " " + obj.response + {"</title>
#   </head>
#   <body>
#     <h1>Error "} + obj.status + " " + obj.response + {"</h1>
#     <p>"} + obj.response + {"</p>
#     <h3>Guru Meditation:</h3>
#     <p>XID: "} + req.xid + {"</p>
#     <hr>
#     <p>Varnish cache server</p>
#   </body>
# </html>
# "};
#     return (deliver);
# }
# 
# sub vcl_init {
# 	return (ok);
# }
# 
# sub vcl_fini {
# 	return (ok);
# }
