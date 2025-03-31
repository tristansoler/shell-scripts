#!/bin/bash

for plan in plan_{1,2}; do
  for day_dir in "$plan"/day_{1,2,3,4,5,6,7}; do
    day_md=$(find "$day_dir" -type f -name "Day.*md")

    for meal in breakfast lunch dinner supper; do
      # Determine next meal for range end (breakfast -> lunch, lunch -> dinner, etc.)
      case $meal in 
        breakfast) next_meal="Lunch";;
        lunch) next_meal="Dinner";;
        dinner) next_meal="Supper";;
        supper) next_meal="END_OF_FILE";;
      esac

      # Extract content
      if [ "$next_meal" != "END_OF_FILE" ]; then
        sed -n "/###${meal^}:/,/###$next_meal:/p" "$day_md" | sed '1d;$d' > "$day_dir/$meal.md"
        # For supper, extract till end of file.
        sed -n "/###${meal^}:/, \$p" "$day_md"
