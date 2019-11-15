#! /bin/bash -x

#constants
declare BET_AMOUNT=1
declare WIN=1
declare GOAL=0
declare BROKE=0
declare DAILY_INITIAL_STAKE=100
declare INFINITE_LOOP=1
declare TWENTY_DAYS=20
declare PERCENT=50

#variables
declare enoughForToday=0
declare stake=0
declare totalAmount=0
declare dailyProfitOrLoss=0
declare monthlyProfitOrLoss=0
declare toContinueNextMonth=0

#setting goal(winning) and broke(losing) conditions
function setGoalAndBroke(){
	local nPercOfStake=$(( $(($DAILY_INITIAL_STAKE * $PERCENT)) / 100 ))
	GOAL=$(( $DAILY_INITIAL_STAKE + $nPercOfStake ))
   BROKE=$(( $DAILY_INITIAL_STAKE - $nPercOfStake ))
}

#perform the action/task of betting
function bet_once(){
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

#check for conditions where gambler reaches goal or goes broke
function checkResign(){
	if [ $stake -ge $GOAL ]
	then
		echo "goal reached..... enough for today "
		enoughForToday=1
	elif [ $stake -le $BROKE ]
	then
		echo "lost too much money...enough for today"
		enoughForToday=1
	fi
}

#sorting dictionaries using function..for reference
function luckiest(){
   luckiestDay=`for day in ${!amountHistory[@]}
                do
                  echo $day" - "${amountHistory[$day]}
                done | sort -nr -k3 | head -1`
	echo $luckiestDay
}

function worst(){
   worstDay=`for day in ${!amountHistory[@]}
           	do
       	     echo $day" - "${amountHistory[$day]}
            done | sort -n -k3 | head -1`
	echo $worstDay
}

#luckiest and worst day using single for loop .... more efficient
function findLuckiestAndWorstDay(){
	local worstDay=0
	local worstDayAmount=$(($GOAL+1))
	local luckiestDay=0
	local luckiestDayAmount=0
	local arrSize=${#amountHistory[@]}
	for key in ${!amountHistory[@]}
	do
		if [ ${amountHistory[$key]} -gt $luckiestDayAmount ]
		then
			luckiestDay=$key
			luckiestDayAmount=${amountHistory[$key]}
		fi
		if [ ${amountHistory[$key]} -lt $worstDayAmount ]
		then
			worstDay=$key
   		worstDayAmount=${amountHistory[$key]}
		fi
	done
}

#start gambling activity for this month
function startGamblingMonth(){
	declare dailyProfitOrLoss=0
	declare monthlyProfitOrLoss=0
	declare -A dailyResult
	declare -A amountHistory

	for (( day=1 ; $day <= $TWENTY_DAYS ; day++ ))
	do
		stake=$DAILY_INITIAL_STAKE
		while [ $INFINITE_LOOP -eq 1 ]
		do
			bet_once
			echo $stake
			if [ $enoughForToday == 1 ]
			then
				enoughForToday=0
				break
			fi
		done
		#storing daily profit or loss amount
		dailyResult[$day]=$(($stake - $DAILY_INITIAL_STAKE))
		#storing cumulative profit or loss amount
		amountHistory[$day]=$(( ${amountHistory[$(($day-1))]} + $(($stake - $DAILY_INITIAL_STAKE)) ))
	done
	findLuckiestAndWorstDay
	#luckiest
	#worst
	toContinueNextMonth=${amountHistory[$TWENTY_DAYS]}
}

#main execution starts  here
setGoalAndBroke
while [ $INFINITE_LOOP -eq 1 ]
do
	if [ $toContinueNextMonth -ge 0 ]
	then
		sleep 2
		startGamblingMonth
	else
		echo "THATS IT!!!!!!!!!!!!!!!! I WONT GAMBLE ANYMORE!! "
		break
	fi
done
