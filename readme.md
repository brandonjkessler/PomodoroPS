# SYNOPSIS
Use the Pomodoro Technique from PowerShell

# DESCRIPTION
Use the Pomodoro Technique from PowerShell. Import the Module and type `Start-Pomodoro` from within PowerShell.
[The Pomodoro Technique: An Effective Time Management Tool](https://science.nichd.nih.gov/confluence/display/newsletter/2020/05/07/The+Pomodoro+Technique%3A+An+Effective+Time+Management+Tool)

# INSTALLATION
1. Save the `PomodoroPS.psm1` to `C:\Program Files\WindowsPowerShell\Modules\PomodoroPS`
1. Run `Import-Module -Name PomodoroPS.psm1`
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


# EXAMPLES