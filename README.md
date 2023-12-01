# OpenRewrite Projects Migrator

## Description

This project is a tool to migrate Java projects to use the OpenRewrite project as batch. Passing the path of the folder where the projects are located, the tool will:
- Set `master` branch.
- Add the OpenRewrite dependency in `pom.xml`.
- Run the OpenRewrite command to migrate the project.
- Create a new branch with the name `migrate-springboot3-java17`.
- Commit the changes and push to the remote repository.
- And then open a browser with the pull request page.

## Requirements
- Java 11
- Git
- Maven
- [Sed](https://www.gnu.org/software/sed/)

## Get Started

Clone the project:
```bash
$ git clone https://stash.pontoslivelo.com.br/scm/~9002331/openrewrite-projects-migrator.git
```

in the folder where you cloned the project, run the command below:
```bash
$ chmod +x openrewrite-projects-migrator.sh
```

and then:
```bash
$ ./openrewrite-projects-migrator.sh <FOLDER_PATH>
```

Where `<FOLDER_PATH>` is the path to the folder where the projects are located.

