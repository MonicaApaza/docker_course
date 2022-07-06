docker pull postgres
docker pull sonarqube
docker pull jenkins/jenkins
docker pull sonatype/nexus3
docker pull portainer/portainer

docker images

driver bridge isolated_network
docker network ls


docker run -d --net=isolated_network --name=postgres -e POSTGRES_PASSWORD=docker -e POSTGRES_USER=app_dev postgres
docker exec -it postgres psql -U app_dev

docker volume create --name sonarqube_data
docker volume create --name sonarqube_logs
docker volume create --name sonarqube_extensions
docker run -d  --net=isolated_network --name sonarqube  -p 9000:9000  -e sonar.jdbc.url=jdbc:postgresql://postgres/postgres  -e sonar.jdbc.username=app_dev -e sonar.jdbc.password=docker -v sonarqube_data:/opt/sonarqube/data  -v sonarqube_extensions:/opt/sonarqube/extensions -v sonarqube_logs:/opt/sonarqube/logs sonarqube

docker volume create --name  jenk_data
docker run -d --net=isolated_network -p 8080:8080 -p 50000:50000 -v jenk_data:/var/jenkins_home jenkins/jenkins

docker volume create --name nexus-data
docker run -d --net=isolated_network -p 8081:8081 --name nexus -v nexus-data:/nexus-data sonatype/nexus3

docker volume create --name portainer_data
docker run -d --net=isolated_network -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer