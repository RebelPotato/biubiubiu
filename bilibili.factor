! Copyright (C) 2023 Peter Huang.
! See https://factorcode.org/license.txt for BSD license.
USING: accessors assocs http http.client json kernel math
sequences strings ;
IN: bilibili

TUPLE: bilibili-key
    { sessdata    string read-only } 
    { bili-jct    string read-only }
    { dedeuserid  string read-only } ;

: <bilibili-key> ( sessdata bili-jct dedeuserid -- key ) 
    bilibili-key boa ;

: sample-key ( -- key )
    "fd5af418%2C1716646568%2Cf79cb%2Ab2CjA4fapD0oxvfuBHNzsMC0MdemCkhzT3qJRg2gh0Sr2cSpq2BzOe25bM5-ssoKP4I9YSVkhjS0NPUjZ3VC1VVnh4eWI1VzlPNi1ObVMxeTdKX2lheUMtcVRYSDhOMXVGXzk2X1Z1aHZIWnNoT1R2QjJmWUVvUGNjZzJlOWZBZHNXc1YwZFZ3WThRIIEC"
    "a371b2a039e877cdf37bbbb9fa84406f"
    "2008607578"
    <bilibili-key> ;

: set-cookie ( response key -- response )
    [ bili-jct>> "bili_jct" <cookie> put-cookie ] keep
    [ sessdata>> "SESSDATA" <cookie> put-cookie ] keep
    dedeuserid>> "DedeUserID" <cookie> put-cookie ;

: set-get-header ( request -- request )
    "keep-alive" "connection" set-header
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36" "User-Agent" set-header
    "https://www.bilibili.com/" "referer" set-header ;

: set-post-header ( request -- request )
    "keep-alive" "connection" set-header
    "https://www.bilibili.com/" "referer" set-header
    "application/json, text/plain, */*" "accept" set-header
    "application/x-www-form-urlencoded" "Content-Type" set-header
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36" "User-Agent" set-header
    "UTF-8" "charset" set-header ;

: get-bilibili ( key url -- request )
    <get-request>
    swap set-cookie
    set-get-header ;

: post-bilibili ( key post-data url -- request )
    <post-request>
    swap set-cookie
    set-post-header ;

ERROR: bad-response ;

: validate* ( response data -- ? )
    [ code>> 200 = ] dip
    "code" of 0 = and ;

: validate ( response data -- data )
    [ validate* ] keep swap
    [ bad-response ] unless ;