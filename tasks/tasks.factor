! Copyright (C) 2023 Peter Huang.
! See https://factorcode.org/license.txt for BSD license.
USING: bilibili bilibili.api kernel prettyprint random ;
IN: bilibili.tasks

! select a random video and watch it
! outputs video, returns status
: watch-random-video ( key -- key ? )
    get-videos random dup . "300" watch-video ;