# GuardianProject

This project is about an application that would be able to detect a danger when activated. It would listen to user's predefined keywords and triggers actions to prevent him/her to get harmed (or as a last resort, to register a proof for further investigation).

## About the project :

### Motivations :

  - Fighting against **closed surroundings aggressions**. Typical exemple, a man or a woman, physically harrased at home 
  
### Developpement :
  - Used **Flutter** for crossplatfrome developpement
  - Developped for *Ios* and *Android*
  - Will be deployed through app downloading center services for each OS **(Goole Play and App store)**

## Objectives :

  - Detects specific hotwords, user defined, and triggers a pre-configured actions
  - Should be undetectable on the device :
    - Fake interface with customizable logo and appName
    - Fake account (if interface requires it) and actual account to access the actual app (for configuration and maybe some statistics)
    
## To use it : (while in developpement)
  - Install Visual studio Code (or any Flutter friendly IDE)
  - Install Flutter SDK
    - Here a [link](https://docs.flutter.dev/get-started/install) to do so
  - Clone repo
  - Use a device emulator (depending on the OS you're using) or your own device while USB debbuging is on (Not sure it is availbale for IOS).
    - Always use last version of SDK
  - If your are not able to lunch application on emulator or your device. Please report an issue. *:warning: So far, only the android app is working :warning:*
  
## Developpement :
If you want to add any developpement to this project, well thanks and be welcome to do it. You will have to compel to some basic rules, so it will be easier for any contributors to add code without harming the project integrity.
The project has no deadlines, so take your time :)

  - Rules :
    1. Any Pull Request need to have an issue (and therefore a project task) associated with it.
        1. If no task are yet created, create it in the `New` column of the project, and if the description of it is mature enough (labels, priority, criticity ...), create an issue from it (it will automatically put the task in the `Todo` column) 
        2. If a task is already created, fill the description (labels, priority, criticity ...), so any new contributor can understand what it is about (it will automatically put the task in the `Todo` column) 
    2. When the task in the **Todo** column, open the issue and attribute yourself for the issue, create a branch and start coding on it (it will automatically put the task in the `In progress` column) . For the branch naming -> if it is a fix, the name should start with `fix/`, otherwise it should start with `dev\`.
    3. Once your code is ready, make a PR, and assign at least one reviewer amongst contributors. You can add several in case you are not sure if the contributors is still active or not. (it will automatically put the task in the `In review` column).
        - On PR, test and compilied check actions will run, if it does not succed, the PR will not be merge, you'll need to fix it before.
    4. As a reviewer, please try to be the more exclusive possible. It is not a way to affirm your way of coding, but to check that the code is understandable by another person and the most efficient possible. Be welcome to add comments if anything is not clear, or if you think something could be improved (in the scope of the issue).
    5. Once the review is approved, you can merge your PR, your branch will be automatically deleted
  
  - Wiki :
    - If you push any code to the repo, please make a wiki page. A template is available for clear description of what you brought (or will be)
    - A page for customer's guide has to be updated if your code has impact on how to use the app. Try to use screenshots
