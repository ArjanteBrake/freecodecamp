#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# Empty the rows in the tables
echo $($PSQL "TRUNCATE games, teams;")

# Insert teams data
# TODO: Complete this section to insert teams from games.csv
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
echo -e "$YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS "
  if [[ $YEAR != 'year' ]]
  then 
    #Get name teams 
    TEAM_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")

    #If not found 
    if [[ -z $TEAM_NAME ]] 
    then 
      #Insert team 
      INSERT_TEAMS=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAMS == "INSERT 0 1" ]]
      then 
        echo Inserted into teams, $WINNER
      fi
    fi

    #Get names opponent
    TEAM_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    
    #if not found 
    if [[ -z $TEAM_NAME ]]
    then    
      #insert opponent team
      INSERT_TEAMS=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAMS == "INSERT 0 1" ]]
      then 
        echo Inserted into teams, $OPPONENT
      fi
    fi
  fi  
done

# Insert games data
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
 if [[ $YEAR != 'year' ]]
 then 
  #get team id 
  TEAM_ID_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
  TEAM_ID_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

  #insert into table 
  INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $TEAM_ID_WINNER, $TEAM_ID_OPPONENT, $WINNER_GOALS, $OPPONENT_GOALS)") 
  if [[ $INSERT_GAMES == "INSERT 0 1" ]]
    then
      echo Inserted into games $ROUND
  fi
 fi
done

# TODO: Complete this section to insert games from games.csv
# Insert games data
