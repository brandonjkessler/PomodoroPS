Function Start-Pomodoro {
    Param(
        # Pomodoro's are 25 minutes long
        [int]$PomodoroMinutes = 25,
        # Breaks are usually 5 minutes long
        [int]$BreakMinutes = 5
    )

    Function Make-Toast{
        param(
            [string]$Text,
            [string]$Title,
            [int]$Milliseconds
        )
        Add-Type -AssemblyName System.Windows.Forms 
        $global:balloon = New-Object System.Windows.Forms.NotifyIcon
        $path = (Get-Process -id $pid).Path
        $balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path) 
        $balloon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info 
        $balloon.BalloonTipText = "$Text"
        $balloon.BalloonTipTitle = "$Title" 
        $balloon.Visible = $true 
        $balloon.ShowBalloonTip($Milliseconds)
    }

    Function Start-Timer{
        param(
            [parameter(Mandatory)]
            [string]$Activity,
            # 1440 minutes equal 24 Hours
            [parameter(Mandatory)]
            [ValidateRange(1,1440)]
            [int]$Minutes,
            [parameter(Mandatory)]
            [ValidateRange(1,1440)]
            [int]$WarningMinutes
            
        )


        if($WarningMinutes -gt $Minutes){
            Write-Warning "You selected $WarningMinutes Warning Minutes and $Minutes Total Minutes. Setting Warning Minutes to 1/5 your Total Minutes."
            $WarningMinutes = [int]($Minutes / 5)

        }

        Write-Host "Starting $Activity for $Minutes minutes. You will be warned when there are $WarningMinutes minutes left."

        [int]$TotalSec = $Minutes * 60
        [int]$StartSec = 0
        [int]$WarnSec = $WarningMinutes * 60
        [int]$WarnSound = 0

        # Better grammar
        if($WarningMinutes -eq 1){
            [string]$WarningText = "Less than $WarningMinutes minute left!"
        } else {
            [string]$WarningText = "Less than $WarningMinutes minutes left!"
        }
        

        ($StartSec)..($TotalSec) | ForEach-Object {
            Start-Sleep -seconds 1
            $percent = (($StartSec/$TotalSec) * 100)
            $timeLeft = $TotalSec - $StartSec
            
            # Test if there are less than Warning seconds left
            if($timeLeft -le $WarnSec){
                if($WarnSound -lt 1){
                    Write-Warning "$WarningText."
                    Make-Toast -Text $WarningText -Title $Activity -Miliseconds $($WarnSec * 1000)
                    #[System.Media.SystemSounds]::Exclamation.Play();
                    $WarnSound++
                }
                
                $status = "Only $($TotalSec - $StartSec) seconds left!"
    
            } else {
                # If it's not under warning Seconds then just give the time
                $status = "$([int]($timeLeft / 60)) minutes left."
            }
            Write-Progress -Activity "$Activity" -Status "$status" -PercentComplete "$percent"
            $StartSec++
        }

        #[System.Media.SystemSounds]::Hand.Play();
        Make-Toast -Text "You completed your $Activity!" -Title $Activity -Miliseconds 60000
        Write-Host "You completed your $Activity!"
    }

    
    
    # Start the Pomodoro
    Start-Timer -Activity 'Pomodoro' -Minutes $PomodoroMinutes -WarningMinutes "$($PomodoroMinutes / 5)"
    # Start the Break
    Start-Timer -Activity 'Break' -Minutes $BreakMinutes -WarningMinutes "$($BreakMinutes / 5)"

}

# ToDo
# - Allow for a set amount of Pomodoro's
# - Log how many total Pomodoro's have been done that day