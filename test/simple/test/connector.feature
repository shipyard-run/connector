Feature: Remote Connector Simple
  In order to test the Remote Connector
  I should setup a remote and a local
  and try to access a service

Scenario: Expose multiple local servics to Remote connector
  Given I have a running blueprint
  Then the following resources should be running
    | name                      | type          |
    | local_connector           | container     |
    | remote_connector          | container     |
    | local_service             | container     |
  When I run the script
    ```
    #!/bin/bash
    sleep 10
    docker logs local-connector.container.shipyard.run

    echo "Expose local service to remote server"
    curl -vv -k https://localhost:9091/expose -d \
      '{
        "name":"test1", 
        "source_port": 13000, 
        "remote_connector_addr": "remote-connector.container.shipyard.run:9092", 
        "destination_addr": "local-service.container.shipyard.run:9094",
        "type": "local"
      }'
    curl -vv -k https://localhost:9091/expose -d \
      '{
        "name":"test2", 
        "source_port": 13001, 
        "remote_connector_addr": "remote-connector.container.shipyard.run:9092", 
        "destination_addr": "local-service.container.shipyard.run:9094",
        "type": "local"
      }'
    curl -vv -k https://localhost:9091/expose -d \
      '{
        "name":"test3", 
        "source_port": 13002, 
        "remote_connector_addr": "remote-connector.container.shipyard.run:9092", 
        "destination_addr": "local-service.container.shipyard.run:9094",
        "type": "local"
      }'
    ```
Then I expect the exit code to be 0
And a HTTP call to "http://localhost:13000" should result in status 200
And a HTTP call to "http://localhost:13001" should result in status 200
And a HTTP call to "http://localhost:13002" should result in status 200

Scenario: Expose remote service to local connector
  Given I have a running blueprint
  Then the following resources should be running
    | name                      | type          |
    | local_connector           | container     |
    | remote_connector          | container     |
    | remote_service            | container     |
  When I run the script
    ```
    #!/bin/bash
    echo "Expose local service to remote server"
    curl -vv -k https://localhost:9091/expose -d \
      '{
        "name":"test", 
        "source_port": 12000, 
        "remote_connector_addr": "remote-connector.container.shipyard.run:9092", 
        "destination_addr": "remote-service.container.shipyard.run:9095",
        "type": "remote"
      }'
    ```
  Then I expect the exit code to be 0
  And a HTTP call to "http://localhost:12000" should result in status 200

Scenario: Expose local and remote services
  Given I have a running blueprint
  Then the following resources should be running
    | name                      | type          |
    | local_connector           | container     |
    | remote_connector          | container     |
    | remote_service            | container     |
  When I run the script
    ```
    #!/bin/bash
    echo "Expose local service to remote server"
    curl -vv -k https://localhost:9091/expose -d \
      '{
        "name":"test", 
        "source_port": 12000, 
        "remote_connector_addr": "remote-connector.container.shipyard.run:9092", 
        "destination_addr": "remote-service.container.shipyard.run:9095",
        "type": "remote"
      }'
    curl -vv -k https://localhost:9091/expose -d \
      '{
        "name":"test1", 
        "source_port": 13000, 
        "remote_connector_addr": "remote-connector.container.shipyard.run:9092", 
        "destination_addr": "local-service.container.shipyard.run:9094",
        "type": "local"
      }'
    ```
  Then I expect the exit code to be 0
  And a HTTP call to "http://localhost:12000" should result in status 200
  And a HTTP call to "http://localhost:13000" should result in status 200
