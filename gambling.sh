#! /bin/bash -x

#constants
declare BET_AMOUNT=1
declare WIN=1
declare GOAL=0
declare BROKE=0
declare DAILY_INITIAL_STAKE=100
declare INFINITE_LOOP=1
declare ENOUGH_FOR_TODAY=0
declare TWENTY_DAYS=20

#variables
declare stake=0
declare totalAmount=0
declare -a dailyResult


function setGoal(){
	GOAL=$(( $stake+$(($stake/2)) ))
}

function setBroke(){
   BROKE=$(( $stake-$(($stake/2)) ))
}

function bet(){  
   betResult=$((RANDOM%2))
	if [ $betResult == $WIN ]
	then
		totalAmount=$(($totalAmount+1))
		stake=$(($stake+$BET_AMOUNT))
	else
		totalAmount=$(($totalAmount-1))
		stake=$(($stake-$BET_AMOUNT))
	fi
	checkResign
}

function checkResign(){
	if [ $stake -ge $GOAL ]
	then
		echo "goal reached..... enough for today "
		ENOUGH_FOR_TODAY=1
	elif [ $stake -le $BROKE ]
	then
		echo "lost too much money...enough for today"
		ENOUGH_FOR_TODAY=1
	fi
}


for (( day=1 ; $day <= $TWENTY_DAYS ; day++ ))
do
	stake=$DAILY_INITIAL_STAKE
	setGoal
	setBroke
	while [ $INFINITE_LOOP -eq 1 ]
	do
		bet
		echo $stake
		if [ $ENOUGH_FOR_TODAY == 1 ]
		then
			ENOUGH_FOR_TODAY=0
			break
		fi
	done
	dailyProfitOrLoss=$(($stake - $DAILY_INITIAL_STAKE))
	monthlyProfitOrLoss=$(($monthlyProfitOrLoss + $dailyProfitOrLoss))
	dailyResult[$day]=$dailyProfitOrLoss
	echo "day ends"
done

