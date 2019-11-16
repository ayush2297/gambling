#! /bin/bash -x

#constants
declare BET_AMOUNT=1
declare WIN=1
declare DAILY_INITIAL_STAKE=100
declare INFINITE_LOOP=1
declare MAX_NUMBER_OF_DAYS=20
declare PERCENT=50

#variables
declare goal=0
declare broke=0
declare enoughForToday=0
declare stake=0
declare totalAmount=0
declare toContinueNextMonth=0

#setting goal(winning) and broke(losing) conditions
function calcNPercOfTotalStake(){
	local nPercOfStake=$(( $(($DAILY_INITIAL_STAKE * $PERCENT)) / 100 ))
	echo $nPercOfStake
}

#setting goal based on initial stake
function setGoal(){
	echo $(($DAILY_INITIAL_STAKE+$1))
}

#setting broke based on initial stake
function setBroke(){
	echo $(($DAILY_INITIAL_STAKE-$1))
}


#perform the action/task of betting
function betOnce(){
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
	if [ $stake -ge $goal ]
	then
		echo "goal reached..... enough for today "
		enoughForToday=1
	elif [ $stake -le $broke ]
	then
		echo "lost too much money...enough for today"
		enoughForToday=1
	fi
}

#sorting dictionaries using function..for reference
function luckiestDayBasedOnAmount(){
   luckiestDay=`for day in ${!amountHistory[@]}
					do
						echo $day" - "${amountHistory[$day]}
					done | sort -nr -k3 | head -1`
	echo $luckiestDay
}

function worstDayBasedOnAmount(){
	worstDay=`for day in ${!amountHistory[@]}
				do
					echo $day" - "${amountHistory[$day]}
				done | sort -n -k3 | head -1`
	echo $worstDay
}

#luckiest and worst day using single for loop .... more efficient
function findLuckiestAndWorstDay(){
	local worstDay=0
	local worstDayAmount=$(($goal+1))
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
	declare -A dailyResult
	declare -A amountHistory

	for (( day=1 ; $day <= $MAX_NUMBER_OF_DAYS ; day++ ))
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
	#luckiestDayBasedOnAmount
	#worstDayBasedOnAmount
	toContinueNextMonth=${amountHistory[$MAX_NUMBER_OF_DAYS]}
}

#main execution starts  here
function executionStartsHere(){
	profitLossMargin=$(calcNPercOfTotalStake)
	goal=$(setGoal $profitLossMargin )
	broke=$(setBroke $profitLossMargin )
	while [ $INFINITE_LOOP -eq 1 ]
	do
		if [ $toContinueNextMonth -ge 0 ]
		then
			sleep 5
			startGamblingMonth
		else
			echo "THATS IT!!!!!!!!!!!!!!!! I WONT GAMBLE ANYMORE!! "
			break
		fi
	done
}

executionStartsHere
