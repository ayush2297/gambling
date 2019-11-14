# /bin/bash -x

declare BET_AMOUNT=1
declare WIN=1

declare stake=100

function bet(){  
   betResult=$((RANDOM%2))
	checkResign
	if [ $betResult == $WIN ]
	then
		stake=$(($stake+$BET_AMOUNT))
	else
		stake=$(($stake-$BET_AMOUNT))
	fi
}

bet
