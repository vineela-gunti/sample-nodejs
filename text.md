# S2I approach for Java based services (Backend services)
1. pom.xml file changes
  - a. Replaced parent confirguration from 
    - <parent>
    -    <groupId>com.bluedart.cosmat</groupId>
    -    <artifactId>c2pc-application</artifactId>
    -    <version>0.0.1-SNAPSHOT</version>
    - </parent>
    - to 
    - <parent>
    -    <groupId>org.springframework.boot</groupId>
    -    <artifactId>spring-boot-starter-parent</artifactId>
    -    <version>2.4.4</version>
    -    <relativePath />
    - </parent>

   - b.  Added properties configuration
    - <properties>
    -    <java.version>11</java.version>
    -    <spring-cloud.version>2020.0.3</spring-cloud.version>
    -    <oracle.version>21.1.0.0</oracle.version>
    -    <blaze.version>1.6.1</blaze.version>
    - </properties>
    - c.  Added commons service dependency 
    - <dependency>
    -    <groupId>com.bluedart.cosmat</groupId>
    -    <artifactId>commons-service</artifactId>
    -    <version>0.0.1-SNAPSHOT</version>
    - </dependency>
2.  Added configuration/settings.xml file in Git with artifactory configurations
3.  Generated json files by triggering openshift/namespace creation job
4. updated s2i image in build.json with openjdk11:latest from ecs-c2ng-build namespace
5. Added configmap object in deployment.json template file and mounted it to DeploymentConfig 
6. Created secret object with DB username and DB password from Openshift console  and mounted it to DeploymentConfig object.
7. Adding environment variable TZ=Asia/Calcutta to DeploymentConfig
8. Create a new job and add the generated Jenskinsfile with deployment stages such as ( build, test, uat)

# S2I approach for NodeJS-Nginx based service (Frontend service)
1. modifying assemble script to perform npm run build:all script while NODE_ENV=production
2. Building s2i image for NodeJS-Nginx image (nodejs-nginx-s2i:latest)
   - podman build -t nodejs-nginx-s2i .
   - podman tag  <image-id> default-route-openshift-image-registry.apps.mykulocp001.dhl.com/ecs-c2ng-build/nodejs-nginx-s2i:latest
   -	podman push default-route-openshift-image-registry.apps.mykulocp001.dhl.com/ecs-c2ng-build/nodejs-nginx-s2i:latest

3. adding custom script in package.json 
"deploy": "rm -rf /usr/share/nginx/html/* && cp -r /opt/app-root/src/dist/* /usr/share/nginx/html/ && nginx -g 'daemon off;'",
4. Generated json files by triggering openshift/namespace creation job
5. Setting environment variable NPM_RUN=deploy to run the custom script "deploy" from package.json in BuildConfig object
6. updated s2i image in build.json with nodejs-nginx-s2i:latest from ecs-c2ng-build namespace
7. Adding environment variable TZ=Asia/Calcutta to DeploymentConfig 
8. Created nginx configmap and mounted it to DeploymentConfig
9. Create a new job and add the generated Jenskinsfile with deployment stages such as ( build, test, uat)
