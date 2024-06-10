#  to-do\
[ ] UI overhaul\
    [ ] iOS-like alarm list\
        [x] switch to toggle each alarm\
        [ ] alarms on by default, off after they go off\
        [x] swipe to remove alarms\
        [x] display alarm range instead of real time\
    [ ] secondary alarm creation window\
        [ ] sensible range picking\
        [ ] selection for notification sound\
    


[ ] Jacob's list of logic that I believe makes sense to work on\
    [ ] Toggling alarm back on reschedules notification and rerolls random time\
        [ ] Write separate schedule function apart from addAlarm\
        [ ] Write method into Alarm struct to reroll time\
        [ ] WARNING: I think the way we have this with the dates rn will make toggling back on not really work\
    [ ] Alarm going off switches toggle switch by changing alarm.isEnabled to false (fixing this fixes UI issue)\
        * This can be done by either adding some kind of observer to the notifications\
        * or by creating some kind of custom notification that not only does banner etc but also flips the isEnabled\
    [ ] Fix print pending notifictions function/come up with way to print all pending notifications\
        * This just will be really helpful for auditing\

        
[ ]Future important work\
    [ ] Schedule alarm should eventually expect notification sound\
    [ ] Schedule alarm should also eventually expect option of more than 1 alarm\
    [ ] notification sound improvement\
    [ ] notifications working when app is open\
    [ ] Generally getting close to fonts of actual IOS alarm app\
