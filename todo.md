# To-do

- [ ] UI overhaul
    - [ ] iOS-like alarm list
        - [x] Switch to toggle each alarm
        - [ ] Alarms on by default, off after they go off
        - [x] Swipe to remove alarms
        - [x] Display alarm range instead of real time
    - [ ] Secondary alarm creation window
        - [ ] Sensible range picking
        - [ ] Selection for notification sound
    
- [ ] Jacob's list of logic that I believe makes sense to work on
    - [ ] Toggling alarm back on reschedules notification and rerolls random time
        - [x] Write separate schedule function apart from `addAlarm`
        - [x] Write method into `Alarm` struct to reroll time
        - [ ] **WARNING:** I think the way we have this with the dates right now will make toggling back on not really work
    - [ ] Alarm going off switches toggle switch by changing `alarm.isEnabled` to `false` (fixing this fixes UI issue)
        - This can be done by either adding some kind of observer to the notifications
        - Or by creating some kind of custom notification that not only does the banner, etc., but also flips the `isEnabled`
    - [ ] Fix print pending notifications function/come up with a way to print all pending notifications
        - This will be really helpful for auditing

- [ ] Future important work
    - [ ] Schedule alarm should eventually expect notification sound
    - [ ] Schedule alarm should also eventually expect the option of more than 1 alarm
    - [ ] Schedule alarm that goes after midnight causes app crash(potentially fixed by removing some date logic)
        - I picture something here that alarm creation defaultly assumes current day
        - Then when alarm goes off, it toggles off and rescheduling will update times with current day
        - Might need logic if random time rolled is before current time
    - [ ] Notification sound improvement
    - [ ] Notifications working when the app is open
    - [ ] Generally getting close to the fonts of the actual iOS alarm app

- Questions
    - IOS only supports dark mode I believe for Alarm. Should we only do dark mode as well?
