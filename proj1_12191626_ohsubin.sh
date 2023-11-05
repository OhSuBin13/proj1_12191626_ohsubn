#! /bin/bash
echo "-------------------------------------------"
echo "User Name: Oh SuBin "
echo "Student Number: 12191626"
echo "[ MENU ]"
echo "1. Get the data of the movie identified by a specific"
echo "'movie id' from 'u.item'" 
echo "2. Get the data of action genre movies from 'u.item'"
echo "3. Get the average 'rating' of the movie identified by"
echo "specific 'movie id' from 'u.data'"
echo "4. Delete the 'IMDb URL' from 'u.item'"
echo "5. Get the data about users from 'u.user'"
echo "6. Modify the format of 'release data' in 'u.item'"
echo "7. Get the data of movies rated by a specific 'user id'"
echo "from 'u.data'"
echo "8. Get the average 'rating' of movies rated by users with"
echo "'age' between 20 and 29 and 'occupation' as 'programmer'"
echo "9. Exit"
echo "----------------------------------------------"

while true
do
	read -p "Enter your choice [ 1-9 ] " reply
	if [ $reply -eq 1 ]
	then
		read -p "Please enter 'movie id' (1~1682) : " m_id
		cat u.item | awk -F '|' -v id="$m_id" '$1 == id'

	elif [ $reply -eq 2 ]
	then
		echo "Do you want to get the data of 'action' genre movies"
		read -p "from 'u.item'? (y/n) :" response
		if [ $response == "y" ]
		then
			cat u.item | awk -F '|' '$7 == 1 {print $1, $2}' | sort -n | head -n 10
		else
			echo "Don't see"
		fi

	elif [ $reply -eq 3 ]
	then		
		read -p "Please enter the 'movie id' (1~1682) : " m_id
		average_rating=$(cat u.data | awk -F '\t' -v id="$m_id" '$2==id {sum += $3; count++} END {print sum/count}')
		printf "average rating of %d : %.5f\n" "$m_id" "$average_rating"	
	
	elif [ $reply -eq 4 ]
	then
		read -p "Do you want to delete the 'IMDb URL' from 'u.item'?(y/n) :" response
		if [ $response == "y" ]
		then
			sed 's/http:[^|]*//' u.item | head -n 10
		else
			echo "rejected"
		fi

	elif [ $reply -eq 5 ]
	then
		echo "Do you want to get the data about users from"
		read -p "'u.user'? (y/n) :" response
		if [ $response == "y" ]
		then
			cat u.user | sed -n '1,10p' | sed 's/\(.*\)|\(.*\)|\(.*\)|\(.*\)|\(.*\)/user \1 is \2 years old \3 \4/' | sed 's/M/male/;s/F/female/'
		else
			echo "rejected"
		fi

	elif [ $reply -eq 6 ]
	then
		read -p "Do you want to Modify the format of 'release data' in 'u.item'?(y/n) :" response
		if [ $response == "y" ]
		then
			cat u.item | sed -E 's/([0-9]+)-([A-Za-z]+)-([0-9]+)/\3\2\1/' | tail -n 10 | sed 's/Jan/01/;s/Feb/02/;s/Mar/03/;s/Apr/04/;s/May/05/;s/Jun/06/;s/Jul/07/;s/Aug/08/;s/Sep/09/;s/Oct/10/;s/Nov/11/;s/Dec/12/'
		else
			echo "rejected"
		fi
	
	elif [ $reply -eq 7 ]
	then
		read -p "Please enter the 'user id' (1~1943) :" u_id
		cat u.data | awk -F '\t' -v user_id="$u_id" '$1 == user_id {print $2}' | sort -n | tr '\n' '|' | sed 's/|$//'
		echo ""
		echo ""	
		awk -F '\t' -v user_id="$u_id" '$1 == user_id {print $2}' u.data | sort -n | head -n 10 | while read -r movie_id;
       	do
		awk -v movie_id="$movie_id" -F '|' '$1 == movie_id {print $1, $2}' u.item | sed 's/ /|/'
       	done

	elif [ $reply -eq 8 ]
	then
		echo ""
		echo "Do you want to get the average 'rating' of"
		echo "movies rated by users with 'age' between 20 and"
		read -p "29 and 'occupation' as 'programmer'?(y/n) :" response
		if [ $response == "y" ]
		then
			cat u.user | awk -F'|' '$2 >= 20 && $2 <= 29 && $4 == "programmer" {print $1}' | while read -r u_id;
		do
			awk -v user_id="$u_id" -F '\t' '$1 == user_id {sum[$2]+=$3; count[$2]++} END{for (i in sum) print i, sum[i]/count[i]}' u.data | sort -n 
		done
		else
			echo "rejected"
		fi
		
	elif [ $reply -eq 9 ]
	then
		break;

	else
		echo "Wrong input"
	fi	
		

done
