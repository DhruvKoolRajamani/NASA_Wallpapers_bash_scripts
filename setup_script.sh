# !bin/bash
#     Bash script to add wallpaper setup script as a cronjob
#     Copyright (C) <2019>  <Dhruv Kool Rajamani>

#     This program is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.

#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.

#     You should have received a copy of the GNU General Public License
#     along with this program.  If not, see <https://www.gnu.org/licenses/>.

# Also add information on how to contact you by electronic and paper mail.

#   If the program does terminal interaction, make it output a short
# notice like this when it starts in an interactive mode:

#     setup_script.sh  Copyright (C) 2019 Dhruv Kool Rajamani
#     This program comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
#     This is free software, and you are welcome to redistribute it
#     under certain conditions; type `show c' for details.

# The hypothetical commands `show w' and `show c' should show the appropriate
# parts of the General Public License.  Of course, your program's commands
# might be different; for a GUI interface, you would use an "about box".

#   You should also get your employer (if you work as a programmer) or school,
# if any, to sign a "copyright disclaimer" for the program, if necessary.
# For more information on this, and how to apply and follow the GNU GPL, see
# <https://www.gnu.org/licenses/>.

#   The GNU General Public License does not permit incorporating your program
# into proprietary programs.  If your program is a subroutine library, you
# may consider it more useful to permit linking proprietary applications with
# the library.  If this is what you want to do, use the GNU Lesser General
# Public License instead of this License.  But first, please read
# <https://www.gnu.org/licenses/why-not-lgpl.html>.

defPath=~/.Wallpapers

minutes="*"
hours="*"
days="*"
months="*"
dow="*"

addToCrontab() {
    crontab -l > wallpaper_script
    echo "" >> wallpaper_script
    echo "# Cron job to call the wallpaper set script repeatedly" >> wallpaper_script
    job="$minutes $hours $days $months $dow"
    echo "$job $wPaperFolderPath/shuffle.sh >> $wPaperFolderPath/cron.log 2>&1" >> wallpaper_script
    crontab wallpaper_script
    rm wallpaper_script
    echo "Added shuffle to cron job"
    echo "To view cron logs, cat $wPaperFolderPath/cron.log"
    exit
}

completeSetup() {
    bashSourceFile=~/.wallpaper.sh
    if [ ! -f "$bashSourceFile" ]; then
        printf "%s" "export wPaperFolderPath=$defPath" > "$bashSourceFile"
    fi
    echo
    echo "Giving privelages to shuffle script"
    source $bashSourceFile
    chmod +x $wPaperFolderPath/shuffle.sh
    echo "Running Script"
    $wPaperFolderPath/shuffle.sh
    echo
    echo "Do you want to add this script to a cronjob?"
    echo "	[n/N/No/no to continue with default path]"
    echo "	Any other key to continue to create a cronjob"
    echo
    read varCron
    declare -a varNo=("n" "N" "NO" "no" "nO" "No")
    for i in "${varNo}"; do
        if [ "$varCron" == "$i" ]; then
            echo "Setup completed!"
            echo "Run ./shuffle.sh if you would like to manually shuffle the wallpapers."
            echo
            exit
        fi
    done
    echo
    check=$(crontab -l | grep -c 'shuffle') #   && echo 'true' || echo 'false'
    if [ $check == '0' ]; then
        echo "How often do you want to shuffle your wallpapers?"
        echo "  Please use the following notation while entering the desired values:"
        echo "      -m <minutes> -h <hours> -d <day> -M <month> -w <day of the week>"
        echo "Example:"
        echo "      -m 5 -h * -d * -M * -w *  -> Will run the chron job every 5 seconds"
        echo ""
        echo "The default value is every 10 minutes. "
        echo "  [n/N/No/no to continue with default value]"
        echo
        read cronTime
        declare -a varNo=("n" "N" "NO" "no" "nO" "No")
        for i in "${varNo}"; do
            if [ "$cronTime" == "$i" ]; then
                echo "Adding default values to crontab"
                addToCrontab
                echo
                exit
            fi
        done
        echo
        
        str=$(echo "$cronTime" | sed 's/*/o/g')
        echo "$str" > $wPaperFolderPath/tempCron.txt
        echo "$(cat $wPaperFolderPath/tempCron.txt | sed 's/ //g')" > $wPaperFolderPath/tempCron.txt
        str="$(cat $wPaperFolderPath/tempCron.txt)"
        
        unformatted=$(echo "$str" | sed 's/^.*-m//')
        minutes=$(echo "$unformatted" | sed 's/-h.*//')
        minutes=$(echo "$minutes" | sed 's/o/*/g')
        
        unformatted=$(echo "$str" | sed 's/^.*-h//')
        hours=$(echo "$unformatted" | sed 's/-d.*//')
        hours=$(echo "$hours" | sed 's/o/*/g')
        
        unformatted=$(echo "$str" | sed 's/^.*-d//')
        days=$(echo "$unformatted" | sed 's/-M.*//')
        days=$(echo "$days" | sed 's/o/*/g')

        unformatted=$(echo "$str" | sed 's/^.*-M//')
        months=$(echo "$unformatted" | sed 's/-w.*//')
        months=$(echo "$months" | sed 's/o/*/g')

        dow=$(echo "$str" | sed 's/^.*-w//')
        dow=$(echo "$dow" | sed 's/o/*/g')

	rm $wPaperFolderPath/tempCron.txt
        
        addToCrontab
    fi
}

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    echo
    echo "Please enter the path to this folder as the first argument"
    echo "The default Path is $defPath"
    exit
    elif [ -z "$1" ]; then
    echo
    echo "The default path is $defPath, if you would like to choose a "
    echo "different path, please enter the path below. "
    echo "	[path to set a new path]"
    echo "	[n/N/No/no to continue with default path]"
    echo
    read varPath
    declare -a varNo=("n" "N" "NO" "no" "nO" "No")
    for i in "${varNo}"; do
        if [ "$varPath" == "$i" ]; then
            completeSetup
            echo
            exit
        fi
    done
    echo
    defPath=$varPath
    completeSetup
    exit
else
    echo
    echo "You have chosen $1 as the path, is this where your files are stored? "
    echo "if you would like to set a different path, please enter the path below. "
    echo "	[path to set a new path]"
    echo "	[y/Y/Yes/yes to continue with $1]"
    echo
    read varPath
    echo
    declare -a varYes=("y" "Y" "YES" "Yes" "yes" "yES" "yeS" "yEs" "YEs")
    for i in "${varYes}"; do
        if [ "$varPath" == "$i" ]; then
            defPath=$1
            completeSetup
            echo
            exit
        fi
    done
    defPath=$varPath
    completeSetup
    echo
    exit
fi
