# Wonder
<p align="center"><img src="https://res.cloudinary.com/startup-grind/image/upload/c_fill,dpr_2,f_auto,g_center,q_auto:good/v1/gcs/platform-data-dsc/contentbuilder/GDG-Bevy-ChapterThumbnail.png" height="200px" width="200px"></p>

Project to participate in 2023 google solution challenge

# Member
 Chanho Park                     | Keo Kim    | Boyoung Kim | SeoKyung Baek |
|------------------------|------------|-------------|---------------|
| - Lead <br/> - Backend | - Frontend | - Frontend  | - AI          |

# UN-SDGs that our solution solving for
## Goal 3. Good Health and Well-Being
<img src="https://user-images.githubusercontent.com/83508073/228183331-9a51e851-0ae2-474e-8511-6ae086b67a1d.png">


# About our solution
Our service is designed to solve the problem of the lack of physical activity of modern people. We tried to solve this problem through walking exercises that anyone can start easily and lightly. 
 
So we added several gamification techniques to help users enjoy walking in their daily lives. The user can make a habit of doing walking exercises and be motivated by watching his or her tier rise.

In addition, there is a function that connects volunteer organizations and users so that they can participate in various volunteer activities that can be done while walking. For example, there are volunteer activities to take a walk with dogs at an abandoned dog shelter or lunch box delivery services for the elderly living alone.


# App Demo

<figure class="third">

![myprofile](https://user-images.githubusercontent.com/83508073/228186679-5a72397b-2b11-4fcc-a433-f4f09133d66c.gif)
![map](https://user-images.githubusercontent.com/83508073/228186705-e6b85ba2-8c21-4ecf-a0da-2df0906322e5.gif)
![voluntary_work](https://user-images.githubusercontent.com/83508073/228186724-2b547cff-32a2-4dd2-bb73-bb65661ea250.gif)
<figure>

# About Implementation
## Backend
### 1. Tech Stack
- Java 11
- Spring, Spring boot
- Spring Web MVC, Spring Security
- Spring Data JPA, QueryDsl
- MySQL
- Docker, Docker-compose
- GCP

### 2. Architecture
![wonder server architecture](https://user-images.githubusercontent.com/83508073/223980536-cc1bd254-3910-43e4-a545-abeb4459b5b5.png)
- I deploy my Spring server application with Docker and Docker Compose.
- First, I create a Dockerfile to build an image of my application.
- Then, I build an image of my application and push to the DockerHub.
- I also create a docker-compose.yml file with information about my spring application from the hub and Nginx and certbot.
  [related issue](https://github.com/KUGODS-Wonder/Wonder-Backend/issues/8)
- Nginx was used to implement the reverse proxy, and certbot was used to use the https protocol.
- Finally, I can start my app with Docker compose by running a command like "docker-compose up". This starts containers for my app.


### 3. Api Docs
[Gitbook](https://cksgh1735.gitbook.io/wonder/)

### 4. ERD
![image](https://user-images.githubusercontent.com/83508073/228537441-d65cff0d-369f-4986-acd2-ecf30f97fce2.png)


## Frontend