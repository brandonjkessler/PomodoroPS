Function Start-Pomodoro {
    Param(
        # Pomodoro's are 25 minutes long
        [int]$PomodoroMinutes = 25,
        # Breaks are usually 5 minutes long
        [int]$BreakMinutes = 5,
        # What are you working on
        [parameter(Mandatory)]
        [string]$Task,
        # Add an optional Project
        [string]$Project = '',
        # Display popups or not
        [bool]$Gui = $true,
        # PAth to log your Pomodoro log file
        [string]$PomodoroLogPath = "$env:USERPROFILE\Documents\PomodoroPS"
    )

    #----------------------------------------------------------------------------
    # FUNCTIONS
    #----------------------------------------------------------------------------

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

    Function Display-MessageBox{
        param(
            [parameter(Mandatory)]
            [string]$Text,
            [parameter(Mandatory)]
            [string]$Title,
            [string]$Button = '0', #OK 0, OKCancel 1, YesNoCancel 3, YesNo 4
            [string]$Icon = 'Asterisk' # None 0, Hand/Error/Stop 16, Question 32, Warning/Exlcamation 48, Asterisk/Information 64
        )

        Add-Type -AssemblyName System.Windows.Forms 
        [System.Windows.Forms.MessageBox]::Show("$Text","$Title","$Button","$Icon")
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
            [ValidateRange(0,1440)]
            [int]$WarningMinutes,
            # Display popups or not
            [bool]$Gui = $true
            
        )

        #----------------------------------------------------------------------------
        # Code
        #----------------------------------------------------------------------------

        # Check to see if the warning minutes is greater than Total Minutes. If it is, that doesn't make sense, so put it to 1/5
        if($WarningMinutes -gt $Minutes){
            Write-Warning "You selected $WarningMinutes Warning Minutes and $Minutes Total Minutes. Setting Warning Minutes to 1/5 your Total Minutes."
            $WarningMinutes = [int]($Minutes / 5)
            if($WarningMinutes -lt 1){
                $WarningMinutes = 1
            }

        }

        # Convert Minutes into Seconds and Set up other Counting Variables
        [int]$TotalSec = $Minutes * 60
        [int]$StartSec = 0
        [int]$WarnSec = $WarningMinutes * 60
        [int]$WarnSound = 0

        #Test if user want's gui popups
        if($Gui -eq $true){
            Display-MessageBox -Text "Starting $Activity for $Minutes minutes. You will be warned when there are $WarningMinutes minutes left." -Title $Activity
            #Make-Toast -Text "Starting $Activity for $Minutes minutes. You will be warned when there are $WarningMinutes minutes left." -Title $Activity -Milliseconds ($WarnSec * 1000)
        }


        Write-Host "Starting $Activity for $Minutes minutes. You will be warned when there are $WarningMinutes minutes left."

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
                    if($Gui -eq $true){
                        #Display-MessageBox -Text $WarningText -Title $Activity
                        Make-Toast -Text $WarningText -Title $Activity -Miliseconds ($WarnSec * 1000)
                    }
                    
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

        if($Gui -eq $true){
            Display-MessageBox -Text "You completed your $Activity!" -Title $Activity
            #Make-Toast -Text "You completed your $Activity!" -Title $Activity -Miliseconds 60000
        }
        Write-Host "You completed your $Activity!"
    }
    
    ## Build a custom object to store information for a csv file
    $Output = [PSCustomObject]@{
        Task = "$Task"
        Project = "$Project"
        Length = "$PomodoroMinutes"
        StartTime = "$(Get-Date -Format hh:mm:ss)"
        EndTime = ''
    }

    # Start the Pomodoro
    Start-Timer -Activity "$Task" -Minutes "$PomodoroMinutes" -WarningMinutes "$($PomodoroMinutes / 5)" -Gui $Gui
    # Check for Pomodoro Log Path
    if((Test-Path -Path $PomodoroLogPath) -ne $true){
        New-Item -Path $PomodoroLogPath -ItemType Directory
    }

    $Output.EndTime = "$(Get-Date -Format hh:mm:ss)"

    $Output | Export-Csv -Path "$PomodoroLogPath\$(Get-Date -Format yyyy-MM-dd)_Pomodoro.csv" -NoTypeInformation -Append
    
    # Start the Break
    Start-Timer -Activity 'Break' -Minutes "$BreakMinutes" -WarningMinutes "$($BreakMinutes / 5)" -Gui $Gui

    

}