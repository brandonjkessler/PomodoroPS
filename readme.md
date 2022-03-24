# SYNOPSIS
Use the Pomodoro Technique from PowerShell

# DESCRIPTION
Use the Pomodoro Technique from PowerShell. Import the Module and type `Start-Pomodoro` from within PowerShell.
[The Pomodoro Technique: An Effective Time Management Tool](https://science.nichd.nih.gov/confluence/display/newsletter/2020/05/07/The+Pomodoro+Technique%3A+An+Effective+Time+Management+Tool)

# INSTALLATION

## Install-Module Script
1. Run the script as an Admin
1. Script will check for the folder to install to, and if it's not there make it
1. Script then copies file(s) over and then imports them

## Manual
1. Save the `PomodoroPS.psm1` to `C:\Program Files\WindowsPowerShell\Modules\PomodoroPS`
1. Run `Import-Module -Name PomodoroPS`
1. ????
1. Profit!

# PARAMETERS
## PomodoroMinutes
- Enter the amount of minutes you want your Pomodoro to be
- Only accepts a range of 1 - 1440
## BreakMinutes
- Enter the amount of minutes you want for a break
- Only accepts a range of 1 - 1440
- If the `BreakMinutes` is greater than `PomodoroMinutes` then `BreakMinutes` is calculated at 1/5 the `PomodoroMinutes`
## Task
- Mandatory
- What are you working on
- String
## Project
- Optional
- Add a Project you are working on
- String
## Gui
- type either `$true` or `$false` to display the popups and notifications, or not.
- Added so that if you want to run completely in CLI you can.
- Boolean
## PomodoroLogPath
- Location to log your progress in a CSV file
- string


# FUNCTIONS
## Start-Timer
- Takes in 3 Parameters
### Activity
- Name of the Activity
- String
### Minutes
- How many minutes the timer should be set for
- Integer
### WarningMinutes
- Minutes to start countdown
- Integer

## Make-Toast
- Pulled from [StackOverflow](https://stackoverflow.com/questions/61971517/powershell-send-a-toast-notification-to-logged-user-when-running-as-local-syste) as figured out by [Andy Bruin](https://stackoverflow.com/users/13663558/andy-bruin)
### Text
- What you want the Toast Notification to say
- String
### Title
- Title of the Toast Notification
- String
### Milliseconds
- Time in Milliseconds to leave the notification up
- Integer

## Display-MessageBox
### Text
- What you want the Popup to Say.
- String

### Title
- Title of the box
- String

### Button
- What kind of Button you want
- String

| Word | Number |
| --- | --- |
| OK | 0 |
| OKCancel | 1 |
| YesNoCancel | 3 |
| YesNo | 4 |

### Icon
- What kind of icon to display
- String

| Word | Number |
| --- | --- |
| None | 0 |
| Hand/error/stop | 16 |
| Question | 32 |
| Warning/Exclamation | 48 |
| Asterisk/Information | 64 |

# EXAMPLES
`Start-PomodoroTimer`

`Start-PomodoroTimer -PomodoroMinutes 50 -BreakMinutes 10`

# To Do
- Allow for a set amount of Pomodoros
- Allow for tracking of Pomodoros. Every 4 Pomodoros you should take a long break.
- Log how many total Pomodoros have been done that day
    - Could use the Set amount of Pomodoros and see if you hit your goal or not, and even a weekly running total
