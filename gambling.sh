#! /bin/bash -x

#constants
declare BET_AMOUNT=1
declare WIN=1
declare GOAL=0
declare BROKE=$(( $stake-$(($stake/2)) ))
declare DAILY_INITIAL_STAKE=100
declare INFINITE_LOOP=1
declare ENOUGH_FOR_TODAY=0

#variables
declare stake=0

function setGoal(){
	GOAL=$(( $stake+$(($stake/2)) ))
}

function setBroke(){
   BROKE=$(( $stake-$(($stake/2)) ))
}

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

stake=$DAILY_INITIAL_STAKE
setGoal
setBroke
echo "DAY : " $day
echo "GOAL : " $GOAL
echo "LEAVE AT: "$BROKE
echo "day begins with stake : "$stake
while [ $INFINITE_LOOP -eq 1 ]
do
	bet
	count=$(($count+1))
	echo $stake
	if [ $ENOUGH_FOR_TODAY == 1 ]
	then
		ENOUGH_FOR_TODAY=0
		break
	fi
done
echo "day ends with $stake"
