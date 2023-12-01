! Copyright (C) 2023 Peter Huang.
! See https://factorcode.org/license.txt for BSD license.
USING: accessors assocs bilibili http.client json kernel make
math math.parser sequences strings urls.encoding ;
IN: bilibili.api


! each kind of data only comes from one source
! get-$data requests $data from its source


TUPLE: bilibili-account
    { uname             string  read-only } 
    { mid               integer read-only }
    { viptype           integer read-only }
    { vipstatus         integer read-only }
    { money             integer read-only }
    { current-exp       integer read-only }
    { coupon-balance    integer read-only } ;

: <bilibili-account> ( uname mid viptype vipstatus money current-exp coupon-balance -- account ) 
    bilibili-account boa ;

: get-account-raw ( key -- data )
    "https://api.bilibili.com/x/web-interface/nav" 
    get-bilibili http-request 
    json> validate ;

: parse-account* ( data -- account )
    [ "uname" of ] keep
    [ "mid" of ] keep
    [ "vipType" of ] keep
    [ "vipStatus" of ] keep
    [ "money" of ] keep
    [ "level_info" of "current_exp" of ] keep
    "wallet" of "coupon_balance" of
    <bilibili-account> ;

: parse-account ( data -- account )
    "data" of parse-account* ;

: get-account* ( key -- account )
    get-account-raw parse-account ;

: get-account ( key -- key account )
    dup get-account* ;


TUPLE: bilibili-video
    { title string  read-only } 
    { aid   integer read-only }
    { bvid  string  read-only }
    { cid   integer read-only } ;

: <bilibili-video> ( title aid bvid cid -- video ) 
    bilibili-video boa ;

! TODO: specify video choice number?

: get-video-raw ( key -- data )
    "https://api.bilibili.com/x/web-interface/dynamic/region?ps=6&rid=1"
    get-bilibili http-request 
    json> validate ;

: parse-video ( data -- video )
    [ "title" of ] keep
    [ "aid" of ] keep
    [ "bvid" of ] keep
    "cid" of 
    <bilibili-video> ;

: parse-videos ( data -- {video} )
    "data" of "archives" of [ parse-video ] map ;

: get-videos* ( key -- {video} )
    get-video-raw parse-videos ;

: get-videos  ( key -- key {video} )
    dup get-videos* ;


! each post action also sends one type of data only
! $do-$something requires $something

TUPLE: watch-video-data
    { video bilibili-video  read-only }
    { time  string          read-only } ;

: <watch-video-data> ( video time -- struct )
    watch-video-data boa ;

:: make-video-post-data ( jct video time -- post-data )
    [ { "aid" } video aid>> number>string suffix ,
      { "cid" } video cid>> number>string suffix ,
      { "progres" time } ,
      { "csrf" jct } ,
    ] { } make assoc>query ;

: watch-video>post-data ( key data -- post-data )
    [ bili-jct>> ] dip
    [ video>> ] [ time>> ] bi
    make-video-post-data ;

: watch-video* ( key data -- ? )
    dupd watch-video>post-data
    "http://api.bilibili.com/x/v2/history/report"
    post-bilibili http-request 
    json> validate* ;

: watch-video ( key video time -- key ? )
    <watch-video-data> dupd watch-video* ;