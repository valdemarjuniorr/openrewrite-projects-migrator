#!/bin/bash

# validate if $1 is set
if [ -z "$1" ]; then
	echo -e "\033[33mPlease provide a path to the directory containing the projects\033[0m"
	exit 1
fi

# list all directories in the specific path and loop through them
for dir in $1/*; do
	# check if the directory is a directory
	if [ -d "$dir" ]; then
		# get the directory name
		dir_name=$(basename "$dir")
		# enter directory folder
		echo "Migration started: $dir_name project"
		cd "$dir"

		# run a git checkout master command
		git checkout master --quiet
		# run a git command to delete branch migrate-springboot3-java17 if it exists
		git branch -D migrate-springboot3-java17 --quiet
		# run a create branch migrate-springboot3-java17 command
        git checkout -b migrate-springboot3-java17 --quiet

		# check if OpenRewrite plugin exists in the pom.xml file
		if grep -q "rewrite-maven-plugin" pom.xml; then
			echo "rewrite-maven-plugin is already set "
		else
			# read the pom.xml file and add the OpenRewrite plugin
			sed -i '' "s|<plugins>|<plugins> \\n \
				<plugin> \\n \
				 <groupId>org.openrewrite.maven<\/groupId> \\n \
				 <artifactId>rewrite-maven-plugin<\/artifactId> \\n \
				 <version>5.13.0<\/version> \\n \
				 <configuration> \\n \
				   <activeRecipes> \\n \
					 <recipe>org.openrewrite.java.spring.boot3.UpgradeSpringBoot_3_1<\/recipe> \\n \
					 <recipe>org.openrewrite.java.migrate.UpgradeToJava17<\/recipe> \\n \
				   <\/activeRecipes> \\n \
				 <\/configuration> \\n \
				 <dependencies> \\n \
				   <dependency> \\n \
					 <groupId>org.openrewrite.recipe<\/groupId> \\n \
					 <artifactId>rewrite-spring<\/artifactId> \\n \
					 <version>5.1.2<\/version> \\n \
				   <\/dependency> \\n \
				 <\/dependencies> \\n \
			   <\/plugin> |g" pom.xml
		fi
		echo "Applying recipe to migrate to Spring Boot 3.1 and Java 17"
		# run OpenRewrite command
		mvn rewrite:run 1> /dev/null
		# print green echo color
		echo -e "\033[32mDone!\033[0m"

		echo "Committing changes to migrate-springboot3-java17 branch"
		# run a git add . command
		git add .
		# run a git commit -m "Migrate to Spring Boot 3.1 and Java 17" command
		git commit -m "Migrate to Spring Boot 3.1 and Java 17" --quiet
		# run a git push origin migrate-springboot3-java17 command
		GIT_PUSH_OUTPUT=$(git push origin migrate-springboot3-java17 2>&1)

		echo -e "\033[32mDone!\033[0m"
		# get url from output command
		PULL_REQUEST_URL=$(grep -Eo "(http|https)://[a-zA-Z0-9./&?=_%:-]*" <<< "$GIT_PUSH_OUTPUT" | head -1)

		# open the pull request url in the browser
		open "$PULL_REQUEST_URL"

		# return to the parent directory
		cd "$1"
	fi
done


