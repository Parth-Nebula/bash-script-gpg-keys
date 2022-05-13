chosekey () {

    counterzenpen=0

    echo

    echo "Kindly Choose the Key you would like to use"

    for i in ${keysIndexarray[@]}

    do

        echo "$((counterzenpen+one))" "${allStringarray[$i]:8:16}" "${namesArray[$counterzenpen]}"

        ((counterzenpen++))

    done

    echo

    read indexChoice

    ((indexChoice--))

    key=${allStringarray[keysIndexarray[indexChoice]]:8:16}

    echo
    echo $key "is your choice"
    echo
    echo "is it final (1 for yes 2 for no) ?"
    echo

    read finalchoice

    if [ $finalchoice -eq 1 ]

    then

        git config --global user.signingkey $key


        echo
        echo "Yeah !!! We have assigned a new key"
        echo

    else

        chosekey

    fi

}

echo
echo "Hello"
echo
echo I will try to help you set/change the GPG key you are signing your commits with
echo
echo 'Please enter whether you would like to create a new key or check for existing keys (1/2)'
echo

read choice

if [ $choice -eq 1 ]

then

    echo

    echo "Let's try to make a new key !!!"

    echo "Key-Type: default" > key.txt

    allStringcurrent="$(gpg --list-secret-keys --keyid-format=long)"

    allStringarrayCurrent=($allStringcurrent)

    emailsIndexarray=()

    fullNamesarray=()

    uid='uid'

    declare -i zero=0

    declare -i one=1

    counter=0

    while [ $counter -lt ${#allStringarrayCurrent[@]} ]

    do

        temp=${allStringarrayCurrent[$counter]}

        if [ "$temp" = "$uid" ]

        then

            tempFullname=""

            ((counter++))
            ((counter++))

            while [ 1 -eq 1 ]

            do

                tempFullname=${tempFullname}" "${allStringarrayCurrent[$counter]}
                ((counter++))

                regex='^[<][a-zA-Z0-9_\-\.]+[@][a-zA-Z0-9_\-]+[.]([c][o][m]|[i][n])[>]$'
            
                if [[ ${allStringarrayCurrent[$counter]} =~ $regex ]]

                then

                    emailsIndexarray+=($counter)

                    break

                fi
            
            done

            tempFullname=`echo $tempFullname | sed 's/ *$//g'` 

            fullNamesarray+=("$tempFullname")

        fi

        ((counter++))

    done




    while [ 1 ]

    do

        while [ 1 ]

        do 

            echo

            echo "Please enter your Full Name ;)"

            echo

            read name

            regex='^[a-zA-Z0-9_\-\. ]+$'
            
            if [[ $name =~ $regex ]]
            
            then

                break

            else
                
                echo

                echo "Wrong format please try again (only Alpha numeric along with . _ - and space are allowed)"

                echo

                continue
            
            fi

        done

        while [ 1 ]

        do 

            echo

            echo "Please enter your Email Id :)"

            echo

            read email

            regex='^[a-zA-Z0-9_\-\.]+[@][a-zA-Z0-9_\-]+[.]([c][o][m]|[i][n])$'
            
            if [[ $email =~ $regex ]]
            
            then

                break

            else

                echo
                
                echo "Wrong format please try again (only *@*.com or *@*.in are allowed)"

                echo

                continue
            
            fi

        done

        counter=0

        check=0

        while [ $counter -lt ${#fullNamesarray[@]} ]

        do

            if [ "$name" = "${fullNamesarray[$counter]}" ]

            then

                tempEmailid=`echo ${allStringarrayCurrent[${emailsIndexarray[$counter]}]} | sed 's/ *$//g'`

                tempSize=${#tempEmailid}

                ((tempSize--))
                ((tempSize--))

                if [ "$email" = "${tempEmailid:1:$tempSize}" ]

                then

                    check=1

                    break

                fi

            fi

            ((counter++))

        done

        if [ $check -eq 0 ]

        then

            echo "Name-Real:" "$name" >> key.txt

            echo "Name-Email:" "$email" >> key.txt

            break

        else

            echo

            echo "Sorry this username and id are already in use"

            echo

        fi

    done

    while [ 1 ]

    do 

        echo
        
        echo "Please enter the comment !!"

        echo

        read comment       

        if [ "$comment" ]

        then 

            echo "Name-Comment:" "$comment" >> key.txt

            break

        else

            break

        fi

    done    

    echo

    echo "Please enter the pass phrase"

    echo

    echo "%ask-passphrase" >> key.txt

    echo "Expire-Date: 0" >> key.txt

    echo "%commit" >>key.txt

    gpg --batch --generate-key key.txt

else

    echo
    echo "Let's choose the key !!"
    echo

fi

allString="$(gpg --list-secret-keys --keyid-format=long)"

allStringarray=($allString)

keysIndexarray=()

namesArray=()

sec='sec'

E='[E]'

uid='uid'

ssb='ssb'

declare -i zero=0

declare -i one=1

counter=0

counterzenpen=0

while [ $counter -lt ${#allStringarray[@]} ]

do

    temp=${allStringarray[$counter]}

    if [ "$temp" = "$sec" ]
    
    then

        ((counter++))

        keysIndexarray+=($counter)

        continue


    elif [ "$temp" = "$uid" ]

    then

        tempName=""

        ((counter++))
        ((counter++))

        while [ 1 -eq 1 ]

        do

            tempName=${tempName}" "${allStringarray[$counter]}
            ((counter++))

            if [ "${allStringarray[$counter]}" = "$ssb" ] || [ "${allStringarray[$counter]}" = "$sec" ] || [ "${allStringarray[$counter]}" = "" ]

            then

                ((counter--))

                break

            fi
        
        done

        namesArray+=("$tempName")

    fi

    ((counter++))

done

if [ $choice -eq 1 ]

then
    
    lastpos=${#keysIndexarray[@]}

    ((lastpos--))

    key=${allStringarray[keysIndexarray[$lastpos]]:8:16}

    git config --global user.signingkey $key

    echo

    echo
    
    echo "Kinldy setup this key on your github using this"

    echo
    echo

    gpg --armor --export $key

else

    chosekey

fi










